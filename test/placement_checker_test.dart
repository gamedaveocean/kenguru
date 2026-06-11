import 'package:flutter_test/flutter_test.dart';
import 'package:kenguru/models/models.dart';
import 'package:kenguru/logic/placement_checker.dart';

void main() {
  group('PlacementChecker', () {
    late PocketShape squareShape;
    late GameItem smallItem;
    late GameItem mediumItem;
    late GameItem largeItem;

    setUp(() {
      // Create a 3x3 square shape
      squareShape = PocketShape(
        name: 'Square',
        cells: [
          const Offset(0, 0), const Offset(1, 0), const Offset(2, 0),
          const Offset(0, 1), const Offset(1, 1), const Offset(2, 1),
          const Offset(0, 2), const Offset(1, 2), const Offset(2, 2),
        ],
      );

      smallItem = GameItem(
        id: 'small',
        type: ItemType.rock,
        shape: ItemShape.small,
        position: Offset.zero,
      );

      mediumItem = GameItem(
        id: 'medium',
        type: ItemType.fruit,
        shape: ItemShape.medium,
        position: Offset.zero,
      );

      largeItem = GameItem(
        id: 'large',
        type: ItemType.toy,
        shape: ItemShape.large,
        position: Offset.zero,
      );
    });

    test('canPlace small item in empty shape', () {
      final result = PlacementChecker.canPlace(
        squareShape,
        const Offset(0, 0),
        smallItem,
        [],
      );
      expect(result, isTrue);
    });

    test('canPlace medium item in empty shape', () {
      final result = PlacementChecker.canPlace(
        squareShape,
        const Offset(0, 0),
        mediumItem,
        [],
      );
      expect(result, isTrue);
    });

    test('canPlace large item in empty shape', () {
      final result = PlacementChecker.canPlace(
        squareShape,
        const Offset(0, 0),
        largeItem,
        [],
      );
      expect(result, isTrue);
    });

    test('cannot place item outside shape', () {
      final result = PlacementChecker.canPlace(
        squareShape,
        const Offset(2, 2),
        largeItem, // 2x2 item at position (2,2) would need cells (2,2), (3,2), (2,3), (3,3)
        [],
      );
      expect(result, isFalse);
    });

    test('cannot place item where already occupied', () {
      final placedItems = [
        PlacedItem(
          item: smallItem,
          gridPosition: const Offset(0, 0),
        ),
      ];

      final result = PlacementChecker.canPlace(
        squareShape,
        const Offset(0, 0),
        smallItem,
        placedItems,
      );
      expect(result, isFalse);
    });

    test('isShapeFilled returns false for empty shape', () {
      final result = PlacementChecker.isShapeFilled(squareShape, []);
      expect(result, isFalse);
    });

    test('isShapeFilled returns true when shape is fully filled', () {
      // Place items that cover all 9 cells of the 3x3 shape
      final placedItems = [
        PlacedItem(item: smallItem, gridPosition: const Offset(0, 0)),
        PlacedItem(item: smallItem, gridPosition: const Offset(1, 0)),
        PlacedItem(item: smallItem, gridPosition: const Offset(2, 0)),
        PlacedItem(item: smallItem, gridPosition: const Offset(0, 1)),
        PlacedItem(item: smallItem, gridPosition: const Offset(1, 1)),
        PlacedItem(item: smallItem, gridPosition: const Offset(2, 1)),
        PlacedItem(item: smallItem, gridPosition: const Offset(0, 2)),
        PlacedItem(item: smallItem, gridPosition: const Offset(1, 2)),
        PlacedItem(item: smallItem, gridPosition: const Offset(2, 2)),
      ];

      final result = PlacementChecker.isShapeFilled(squareShape, placedItems);
      expect(result, isTrue);
    });

    test('isShapeFilled returns false when shape has empty cells', () {
      final placedItems = [
        PlacedItem(item: smallItem, gridPosition: const Offset(0, 0)),
        PlacedItem(item: smallItem, gridPosition: const Offset(1, 0)),
        // Missing cells
      ];

      final result = PlacementChecker.isShapeFilled(squareShape, placedItems);
      expect(result, isFalse);
    });

    test('getOccupiedCells returns correct cells', () {
      final placedItems = [
        PlacedItem(item: smallItem, gridPosition: const Offset(0, 0)),
        PlacedItem(item: smallItem, gridPosition: const Offset(1, 1)),
      ];

      final occupiedCells = PlacementChecker.getOccupiedCells(placedItems);
      expect(occupiedCells.length, 2);
      expect(occupiedCells.contains(const Offset(0, 0)), isTrue);
      expect(occupiedCells.contains(const Offset(1, 1)), isTrue);
    });
  });
}