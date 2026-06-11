import 'package:flutter/material.dart';
import '../models/models.dart';
import '../logic/placement_checker.dart';
import '../painters/pocket_painter.dart';
import 'draggable_item.dart';

class PocketWidget extends StatefulWidget {
  final PocketShape shape;
  final List<PlacedItem> placedItems;
  final List<GameItem> collectedItems;
  final Function(GameItem, Offset) onItemPlaced;
  final Function() onShapeFilled;

  const PocketWidget({
    super.key,
    required this.shape,
    required this.placedItems,
    required this.collectedItems,
    required this.onItemPlaced,
    required this.onShapeFilled,
  });

  @override
  State<PocketWidget> createState() => _PocketWidgetState();
}

class _PocketWidgetState extends State<PocketWidget> {
  Offset? _highlightedCell;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Карман: ${widget.shape.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Pocket area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cellSize = _calculateCellSize(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                return Stack(
                  children: [
                    // Pocket shape painter
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(cellSize / 4),
                        child: DragTarget<GameItem>(
                          onWillAcceptWithDetails: (details) {
                            final renderBox = context.findRenderObject() as RenderBox;
                            final localPos = renderBox.globalToLocal(details.offset);
                            final dropPos = PlacementChecker.findDropPosition(
                              widget.shape,
                              localPos,
                              cellSize,
                              widget.placedItems,
                            );
                            setState(() => _highlightedCell = dropPos);
                            return dropPos != null && canPlaceItem(details.data, dropPos);
                          },
                          onLeave: (_) {
                            setState(() => _highlightedCell = null);
                          },
                          onAcceptWithDetails: (details) {
                            final renderBox = context.findRenderObject() as RenderBox;
                            final localPos = renderBox.globalToLocal(details.offset);
                            final dropPos = PlacementChecker.findDropPosition(
                              widget.shape,
                              localPos,
                              cellSize,
                              widget.placedItems,
                            );
                            if (dropPos != null && canPlaceItem(details.data, dropPos)) {
                              widget.onItemPlaced(details.data, dropPos);
                              setState(() => _highlightedCell = null);
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            return CustomPaint(
                              painter: PocketPainter(
                                shape: widget.shape,
                                occupiedCells: PlacementChecker.getOccupiedCells(widget.placedItems),
                                highlightedCell: _highlightedCell,
                              ),
                              size: Size.infinite,
                            );
                          },
                        ),
                      ),
                    ),
                    // Placed items
                    ...widget.placedItems.map((placed) {
                      return Positioned(
                        left: placed.gridPosition.dx * cellSize + cellSize / 8,
                        top: placed.gridPosition.dy * cellSize + cellSize / 8,
                        child: _buildPlacedItem(placed, cellSize),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          // Collected items
          if (widget.collectedItems.isNotEmpty)
            Container(
              height: 80,
              padding: const EdgeInsets.all(8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.collectedItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = widget.collectedItems[index];
                  return DraggableItemWidget(item: item);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlacedItem(PlacedItem placed, double cellSize) {
    return Container(
      width: placed.item.width * cellSize - cellSize / 4,
      height: placed.item.height * cellSize - cellSize / 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Center(
        child: Text(
          placed.item.emoji,
          style: TextStyle(fontSize: cellSize * 0.5),
        ),
      ),
    );
  }

  double _calculateCellSize(double maxWidth, double maxHeight) {
    final cellW = maxWidth / widget.shape.width;
    final cellH = maxHeight / widget.shape.height;
    return (cellW < cellH ? cellW : cellH) * 0.9;
  }

  bool canPlaceItem(GameItem item, Offset position) {
    return PlacementChecker.canPlace(
      widget.shape,
      position,
      item,
      widget.placedItems,
    );
  }
}