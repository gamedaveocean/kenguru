import 'dart:ui';

enum ItemType { rock, fruit, toy }

enum ItemShape { small, medium, large } // 1x1, 2x1, 2x2 cells

class GameItem {
  final String id;
  final ItemType type;
  final ItemShape shape;
  Offset position;
  bool isCollected;

  GameItem({
    required this.id,
    required this.type,
    required this.shape,
    required this.position,
    this.isCollected = false,
  });

  int get width {
    switch (shape) {
      case ItemShape.small:
        return 1;
      case ItemShape.medium:
        return 2;
      case ItemShape.large:
        return 2;
    }
  }

  int get height {
    switch (shape) {
      case ItemShape.small:
        return 1;
      case ItemShape.medium:
        return 1;
      case ItemShape.large:
        return 2;
    }
  }

  List<Offset> getCells() {
    List<Offset> cells = [];
    for (int dx = 0; dx < width; dx++) {
      for (int dy = 0; dy < height; dy++) {
        cells.add(Offset(dx.toDouble(), dy.toDouble()));
      }
    }
    return cells;
  }

  String get emoji {
    switch (type) {
      case ItemType.rock:
        return '💎';
      case ItemType.fruit:
        return '🍎';
      case ItemType.toy:
        return '🧸';
    }
  }

  GameItem copyWith({
    String? id,
    ItemType? type,
    ItemShape? shape,
    Offset? position,
    bool? isCollected,
  }) {
    return GameItem(
      id: id ?? this.id,
      type: type ?? this.type,
      shape: shape ?? this.shape,
      position: position ?? this.position,
      isCollected: isCollected ?? this.isCollected,
    );
  }
}