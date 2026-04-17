import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/emoji_item.dart';
import 'recipe_manager.dart';
import 'ad_manager.dart';

enum GameMode { sandbox, adventure, challenge }

class GameController extends ChangeNotifier {
  Set<String> _discoveredEmojis = {};
  List<EmojiItem> _canvasEmojis = [];
  bool _isLoading = true;
  String? _selectedCategory = "All";
  String _searchQuery = "";
  String? _lastDiscoveredEmoji;
  String? _selectedInventoryEmoji;
  bool _vibrationEnabled = true;

  Set<String> get discoveredEmojis => _discoveredEmojis;
  List<EmojiItem> get canvasEmojis => _canvasEmojis;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory ?? "All";
  String get searchQuery => _searchQuery;
  String? get lastDiscoveredEmoji => _lastDiscoveredEmoji;
  String? get selectedInventoryEmoji => _selectedInventoryEmoji;
  bool get vibrationEnabled => _vibrationEnabled;
  GameMode get currentMode => _currentMode;
  String? get challengeTarget => _challengeTarget;

  List<String> get filteredInventory {
    Iterable<String> base;
    if (_currentMode == GameMode.sandbox || _currentMode == GameMode.challenge) {
      base = RecipeManager.recipes.values.toSet()..addAll(RecipeManager.getStartingEmojis());
    } else {
      base = _discoveredEmojis;
    }

    // Filter by category
    if (_selectedCategory != "All") {
      base = base.where((e) => RecipeManager.getEmojiCategory(e) == _selectedCategory);
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      base = base.where((e) {
        final meaning = RecipeManager.meanings[e]?.toLowerCase() ?? "";
        return e.contains(_searchQuery) || meaning.contains(_searchQuery.toLowerCase());
      });
    }

    return base.toList()..sort();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  int get totalPossible => RecipeManager.recipes.values.toSet().length + RecipeManager.getStartingEmojis().length;

  GameController() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('discovered_emojis');
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    if (saved != null && saved.isNotEmpty) {
      _discoveredEmojis = saved.toSet();
    } else {
      _discoveredEmojis = RecipeManager.getStartingEmojis().toSet();
    }
    _isLoading = false;
    notifyListeners();
  }

  void toggleVibration() async {
    _vibrationEnabled = !_vibrationEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _discoveredEmojis = RecipeManager.getStartingEmojis().toSet();
    clearCanvas();
    _init(); // Reload
  }

  void setMode(GameMode mode) {
    _currentMode = mode;
    clearCanvas();
    if (mode == GameMode.challenge) {
      _pickNewChallenge();
    }
    notifyListeners();
  }

  void _pickNewChallenge() {
    final possibleWithClues = RecipeManager.clues.keys.toList();
    _challengeTarget = (possibleWithClues..shuffle()).first;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('discovered_emojis', _discoveredEmojis.toList());
  }

  void addEmojiToCanvas(String emoji, Offset position) {
    final newItem = EmojiItem(
      emoji: emoji,
      position: position,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _canvasEmojis.add(newItem);
    notifyListeners();
  }

  void updateEmojiPosition(String id, Offset newPosition) {
    final index = _canvasEmojis.indexWhere((e) => e.id == id);
    if (index != -1) {
      _canvasEmojis[index] = _canvasEmojis[index].copyWith(position: newPosition);
      notifyListeners();
    }
  }

  void removeEmoji(String id) {
    _canvasEmojis.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clearCanvas() {
    _canvasEmojis.clear();
    notifyListeners();
  }

  bool checkCollision(EmojiItem dragged) {
    for (var other in _canvasEmojis) {
      if (other.id == dragged.id) continue;

      final distance = (dragged.position - other.position).distance;
      if (distance < 50) {
        final result = RecipeManager.combine(dragged.emoji, other.emoji);
        if (result != null) {
          _handleMerge(dragged, other, result);
          return true;
        }
        return false;
      }
    }
    return false;
  }

  void _handleMerge(EmojiItem e1, EmojiItem e2, String result) {
    final mergePosition = Offset(
      (e1.position.dx + e2.position.dx) / 2,
      (e1.position.dy + e2.position.dy) / 2,
    );

    removeEmoji(e1.id);
    removeEmoji(e2.id);
    addEmojiToCanvas(result, mergePosition);

    if (!_discoveredEmojis.contains(result)) {
      _discoveredEmojis.add(result);
      _save();
      _vibrate(intensity: 100);
      _lastDiscoveredEmoji = result;
      if (_currentMode == GameMode.adventure) {
        AdManager.showDiscoveryAd();
      }
    } else {
      _vibrate(intensity: 50);
    }

    if (_currentMode == GameMode.challenge && result == _challengeTarget) {
      _vibrate(intensity: 150);
      _pickNewChallenge();
    }
    
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectInventoryEmoji(String? emoji) {
    _selectedInventoryEmoji = emoji;
    notifyListeners();
  }

  void clearLastDiscovered() {
    _lastDiscoveredEmoji = null;
    notifyListeners();
  }

  Future<void> _vibrate({int intensity = 50}) async {
    if (!_vibrationEnabled) return;
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: intensity);
    }
  }

  String? getHint() {
    return RecipeManager.getHint(_discoveredEmojis);
  }

  void unlockRandom() {
    final allPossibleResult = RecipeManager.recipes.values.toSet();
    final locked = allPossibleResult.difference(_discoveredEmojis);
    if (locked.isNotEmpty) {
      final randomEmoji = (locked.toList()..shuffle()).first;
      _discoveredEmojis.add(randomEmoji);
      _save();
      notifyListeners();
    }
  }
}
