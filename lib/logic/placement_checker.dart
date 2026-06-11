import 'dart:ui';
import '../models/models.dart';

class PlacedItem {
  final GameItem item;
  final Offset gridPosition;

  PlacedItem({required this.item, required this.gridPosition});
}

class PlacementChecker {
  static bool canPlace(PocketShape shape, Offset position, GameItem item, List<PlacedItem> placedItems) {
    // Check if all cells for this item are within the shape and not occupied
    final cells = item.getCells();
    
    for (final cell in cells) {
      final targetCell = Offset(
        position.dx + cell.dx,
        position.dy + cell.dy,
      );
      
      // Check if cell is within shape
      if (!shape.cells.contains(targetCell)) {
        return false;
      }
      
      // Check if cell is already occupied
      for (final placed in placedItems) {
        final placedCells = placed.item.getCells();
        for (final pc in placedCells) {
          if (placed.gridPosition + pc == targetCell) {
            return false;
          }
        }
      }
    }
    
    return true;
  }

  static bool isShapeFilled(PocketShape shape, List<PlacedItem> placedItems) {
    final occupiedCells = <Offset>{};
    
    for (final placed in placedItems) {
      final cells = placed.item.getCells();
      for (final cell in cells) {
        occupiedCells.add(placed.gridPosition + cell);
      }
    }
    
    // Check if all shape cells are occupied
    for (final shapeCell in shape.cells) {
      if (!occupiedCells.contains(shapeCell)) {
        return false;
      }
    }
    
    return true;
  }

  static Set<Offset> getOccupiedCells(List<PlacedItem> placedItems) {
    final occupiedCells = <Offset>{};
    
    for (final placed in placedItems) {
      final cells = placed.item.getCells();
      for (final cell in cells) {
        occupiedCells.add(placed.gridPosition + cell);
      }
    }
    
    return occupiedCells;
  }

  static Offset? findDropPosition(PocketShape shape, Offset localPosition, double cellSize, List<PlacedItem> placedItems) {
    final gridX = (localPosition.dx / cellSize).floor();
    final gridY = (localPosition.dy / cellSize).floor();
    final gridPos = Offset(gridX.toDouble(), gridY.toDouble());
    
    // Check if position is within shape
    if (!shape.cells.contains(gridPos)) {
      return null;
    }
    
    return gridPos;
  }
}