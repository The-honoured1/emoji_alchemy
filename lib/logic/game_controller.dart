import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/emoji_item.dart';
import 'recipe_manager.dart';
import 'ad_manager.dart';

class GameController extends ChangeNotifier {
  Set<String> _discoveredEmojis = {};
  List<EmojiItem> _canvasEmojis = [];
  bool _isLoading = true;
  String _selectedCategory = "All";
  String? _lastDiscoveredEmoji;

  Set<String> get discoveredEmojis => _discoveredEmojis;
  List<EmojiItem> get canvasEmojis => _canvasEmojis;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String? get lastDiscoveredEmoji => _lastDiscoveredEmoji;

  List<String> get filteredInventory {
    if (_selectedCategory == "All") return _discoveredEmojis.toList()..sort();
    return _discoveredEmojis.where((e) => RecipeManager.getEmojiCategory(e) == _selectedCategory).toList()..sort();
  }

  int get totalPossible => RecipeManager.recipes.values.toSet().length + RecipeManager.getStartingEmojis().length;

  GameController() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('discovered_emojis');
    if (saved != null && saved.isNotEmpty) {
      _discoveredEmojis = saved.toSet();
    } else {
      _discoveredEmojis = RecipeManager.getStartingEmojis().toSet();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('discovered_emojis', _discoveredEmojis.toList());
  }

  void addEmojiToCanvas(String emoji, Offset position) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _canvasEmojis.add(EmojiItem(emoji: emoji, id: id, position: position));
    notifyListeners();
  }

  void updateEmojiPosition(String id, Offset newPosition) {
    final index = _canvasEmojis.indexWhere((e) => e.id == id);
    if (index != -1) {
      _canvasEmojis[index].position = newPosition;
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
      if (distance < 60) { // Collision threshold
        final result = RecipeManager.combine(dragged.emoji, other.emoji);
        if (result != null) {
          _handleMerge(dragged, other, result);
          return true;
        } else {
          // Subtle shake feedback for invalid combination
          _vibrate(intensity: 30);
          return false;
        }
      }
    }
    return false;
  }

  void _handleMerge(EmojiItem e1, EmojiItem e2, String result) {
    final mergePosition = (e1.position + e2.position) / 2;
    removeEmoji(e1.id);
    removeEmoji(e2.id);
    
    addEmojiToCanvas(result, mergePosition);

    if (!_discoveredEmojis.contains(result)) {
      _discoveredEmojis.add(result);
      _save();
      _vibrate(intensity: 100);
      _lastDiscoveredEmoji = result; // Trigger UI event
      AdManager.showDiscoveryAd(); 
    } else {
      _vibrate(intensity: 50);
    }
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearLastDiscovered() {
    _lastDiscoveredEmoji = null;
    notifyListeners();
  }

  void _vibrate({int intensity = 50}) async {
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
