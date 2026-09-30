import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'recipes.dart';

/// Starter emojis always available to the player.
const kStarters = ['🔥', '💧', '🌍', '💨'];

class GameState extends ChangeNotifier {
  // All emojis the player has unlocked (persisted).
  final Set<String> _unlocked = {};

  // Emojis currently selected on the mixing board (up to 3).
  final List<String> _selected = [];

  // Recently discovered emoji (shown in banner).
  String? _justDiscovered;
  String? _justDiscoveredName;

  // Sorted list of unlocked emojis for display.
  List<String> get unlockedList {
    final all = _unlocked.toList();
    all.sort();
    return all;
  }

  List<String> get selected => List.unmodifiable(_selected);
  String? get justDiscovered => _justDiscovered;
  String? get justDiscoveredName => _justDiscoveredName;

  GameState() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('unlocked');
    if (saved != null && saved.isNotEmpty) {
      _unlocked.addAll(saved);
    } else {
      _unlocked.addAll(kStarters);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('unlocked', _unlocked.toList());
  }

  /// Toggle an emoji in the selection tray (max 3 slots).
  void toggleSelect(String emoji) {
    if (_selected.contains(emoji)) {
      _selected.remove(emoji);
    } else if (_selected.length < 3) {
      _selected.add(emoji);
    }
    _justDiscovered = null;
    notifyListeners();
  }

  void clearSelection() {
    _selected.clear();
    _justDiscovered = null;
    notifyListeners();
  }

  /// Attempt to combine the selected emojis.
  /// Returns true if a new combination was found.
  bool combine() {
    if (_selected.isEmpty) return false;
    final sorted = [..._selected]..sort();

    for (final recipe in kRecipes) {
      final inputs = List<String>.from(recipe['inputs'] as List)..sort();
      if (listEquals(inputs, sorted)) {
        final output = recipe['output'] as String;
        final name = recipe['name'] as String;
        final isNew = !_unlocked.contains(output);
        _unlocked.add(output);
        _selected.clear();
        _justDiscovered = output;
        _justDiscoveredName = name;
        _save();
        notifyListeners();
        return isNew;
      }
    }

    // No recipe found — clear and signal failure
    _selected.clear();
    _justDiscovered = null;
    notifyListeners();
    return false;
  }

  /// Reset game (debug / settings).
  Future<void> resetGame() async {
    _unlocked
      ..clear()
      ..addAll(kStarters);
    _selected.clear();
    _justDiscovered = null;
    await _save();
    notifyListeners();
  }

  int get totalRecipes => kRecipes.length;
  int get discoveredCount => _unlocked.length - kStarters.length;
}
