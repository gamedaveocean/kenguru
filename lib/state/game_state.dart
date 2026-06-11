import 'package:flutter/material.dart';
import '../models/models.dart';
import '../logic/placement_checker.dart';

enum GamePhase { collecting, placing, completed }

class GameState extends ChangeNotifier {
  List<GameItem> _collectedItems = [];
  List<PlacedItem> _placedItems = [];
  int _currentLevelIndex = 0;
  GamePhase _phase = GamePhase.collecting;
  int _currentPlatformIndex = 0;
  List<GameItem> _levelItems = [];

  List<GameItem> get collectedItems => _collectedItems;
  List<PlacedItem> get placedItems => _placedItems;
  int get currentLevelIndex => _currentLevelIndex;
  GamePhase get phase => _phase;
  int get currentPlatformIndex => _currentPlatformIndex;
  List<GameItem> get levelItems => _levelItems;

  void initLevel(Level level) {
    _collectedItems = [];
    _placedItems = [];
    _phase = GamePhase.collecting;
    _currentPlatformIndex = 0;
    _levelItems = level.availableItems.map((item) => item.copyWith()).toList();
    notifyListeners();
  }

  void collectItem(GameItem item) {
    final index = _levelItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _levelItems[index].isCollected = true;
      _collectedItems.add(_levelItems[index]);
      
      // Check if all items collected
      final allCollected = _levelItems.every((i) => i.isCollected);
      if (allCollected) {
        _phase = GamePhase.placing;
      }
      notifyListeners();
    }
  }

  void placeItem(GameItem item, Offset position) {
    // Remove from collected items
    _collectedItems.removeWhere((i) => i.id == item.id);
    
    // Add to placed items
    final placedItem = PlacedItem(item: item, gridPosition: position);
    _placedItems.add(placedItem);
    
    notifyListeners();
  }

  bool checkCompletion(PocketShape shape) {
    if (PlacementChecker.isShapeFilled(shape, _placedItems)) {
      _phase = GamePhase.completed;
      notifyListeners();
      return true;
    }
    return false;
  }

  void nextLevel() {
    _currentLevelIndex++;
    notifyListeners();
  }

  void setPlatformIndex(int index) {
    _currentPlatformIndex = index;
    notifyListeners();
  }

  bool isItemNearKangaroo(GameItem item, List<Offset> platforms, int platformIndex) {
    if (platformIndex >= platforms.length) return false;
    
    final kangarooPos = platforms[platformIndex];
    final distance = (item.position - kangarooPos).distance;
    return distance < 0.15; // Adjust threshold as needed
  }
}