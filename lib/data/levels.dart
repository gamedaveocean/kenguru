import 'dart:ui';
import '../models/models.dart';

final List<Level> gameLevels = [
  // Level 1: Simple 3x3 square
  Level(
    id: 1,
    name: 'Квадрат',
    pocketShape: PocketShape(
      name: 'Квадрат 3x3',
      cells: [
        const Offset(0, 0), const Offset(1, 0), const Offset(2, 0),
        const Offset(0, 1), const Offset(1, 1), const Offset(2, 1),
        const Offset(0, 2), const Offset(1, 2), const Offset(2, 2),
      ],
    ),
    platformPositions: [
      const Offset(0.2, 0.3),
      const Offset(0.5, 0.5),
      const Offset(0.8, 0.3),
      const Offset(0.5, 0.15),
    ],
    availableItems: [
      GameItem(id: '1', type: ItemType.rock, shape: ItemShape.medium, position: const Offset(0.25, 0.45)),
      GameItem(id: '2', type: ItemType.fruit, shape: ItemShape.small, position: const Offset(0.45, 0.25)),
      GameItem(id: '3', type: ItemType.toy, shape: ItemShape.small, position: const Offset(0.55, 0.65)),
      GameItem(id: '4', type: ItemType.rock, shape: ItemShape.small, position: const Offset(0.75, 0.45)),
      GameItem(id: '5', type: ItemType.fruit, shape: ItemShape.small, position: const Offset(0.45, 0.05)),
      GameItem(id: '6', type: ItemType.toy, shape: ItemShape.large, position: const Offset(0.5, 0.7)),
    ],
  ),
  
  // Level 2: T-shape
  Level(
    id: 2,
    name: 'Буква Т',
    pocketShape: PocketShape(
      name: 'Буква Т',
      cells: [
        const Offset(0, 0), const Offset(1, 0), const Offset(2, 0),
        const Offset(1, 1),
        const Offset(1, 2),
      ],
    ),
    platformPositions: [
      const Offset(0.2, 0.4),
      const Offset(0.5, 0.6),
      const Offset(0.8, 0.4),
    ],
    availableItems: [
      GameItem(id: '1', type: ItemType.rock, shape: ItemShape.medium, position: const Offset(0.25, 0.55)),
      GameItem(id: '2', type: ItemType.fruit, shape: ItemShape.small, position: const Offset(0.55, 0.35)),
      GameItem(id: '3', type: ItemType.toy, shape: ItemShape.large, position: const Offset(0.75, 0.55)),
    ],
  ),
  
  // Level 3: Heart shape
  Level(
    id: 3,
    name: 'Сердце',
    pocketShape: PocketShape(
      name: 'Сердце',
      cells: [
        const Offset(0, 0), const Offset(1, 0),
        const Offset(0, 1), const Offset(1, 1), const Offset(2, 1),
        const Offset(1, 2),
      ],
    ),
    platformPositions: [
      const Offset(0.2, 0.5),
      const Offset(0.5, 0.3),
      const Offset(0.8, 0.5),
    ],
    availableItems: [
      GameItem(id: '1', type: ItemType.rock, shape: ItemShape.small, position: const Offset(0.25, 0.35)),
      GameItem(id: '2', type: ItemType.fruit, shape: ItemShape.small, position: const Offset(0.55, 0.6)),
      GameItem(id: '3', type: ItemType.toy, shape: ItemShape.medium, position: const Offset(0.75, 0.35)),
    ],
  ),
  
  // Level 4: L-shape
  Level(
    id: 4,
    name: 'Уголок',
    pocketShape: PocketShape(
      name: 'Уголок',
      cells: [
        const Offset(0, 0),
        const Offset(0, 1),
        const Offset(0, 2),
        const Offset(1, 2),
        const Offset(2, 2),
      ],
    ),
    platformPositions: [
      const Offset(0.3, 0.4),
      const Offset(0.6, 0.6),
    ],
    availableItems: [
      GameItem(id: '1', type: ItemType.rock, shape: ItemShape.large, position: const Offset(0.35, 0.55)),
      GameItem(id: '2', type: ItemType.fruit, shape: ItemShape.small, position: const Offset(0.65, 0.35)),
    ],
  ),
  
  // Level 5: Plus shape
  Level(
    id: 5,
    name: 'Плюс',
    pocketShape: PocketShape(
      name: 'Плюс',
      cells: [
        const Offset(1, 0),
        const Offset(0, 1), const Offset(1, 1), const Offset(2, 1),
        const Offset(1, 2),
      ],
    ),
    platformPositions: [
      const Offset(0.2, 0.4),
      const Offset(0.5, 0.2),
      const Offset(0.8, 0.4),
      const Offset(0.5, 0.6),
    ],
    availableItems: [
      GameItem(id: '1', type: ItemType.rock, shape: ItemShape.medium, position: const Offset(0.25, 0.55)),
      GameItem(id: '2', type: ItemType.fruit, shape: ItemShape.small, position: const Offset(0.55, 0.35)),
      GameItem(id: '3', type: ItemType.toy, shape: ItemShape.small, position: const Offset(0.75, 0.55)),
      GameItem(id: '4', type: ItemType.rock, shape: ItemShape.small, position: const Offset(0.55, 0.75)),
    ],
  ),
];