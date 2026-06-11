import 'dart:ui';
import 'item.dart';
import 'pocket_shape.dart';

class Level {
  final int id;
  final String name;
  final PocketShape pocketShape;
  final List<Offset> platformPositions;
  final List<GameItem> availableItems;

  Level({
    required this.id,
    required this.name,
    required this.pocketShape,
    required this.platformPositions,
    required this.availableItems,
  });
}