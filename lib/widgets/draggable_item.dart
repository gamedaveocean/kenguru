import 'package:flutter/material.dart';
import '../models/models.dart';

class DraggableItemWidget extends StatelessWidget {
  final GameItem item;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  const DraggableItemWidget({
    super.key,
    required this.item,
    this.onDragStarted,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<GameItem>(
      data: item,
      onDragStarted: onDragStarted,
      onDragEnd: (_) => onDragEnd?.call(),
      feedback: Material(
        color: Colors.transparent,
        child: _ItemDisplay(item: item, isDragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _ItemDisplay(item: item),
      ),
      child: _ItemDisplay(item: item),
    );
  }
}

class _ItemDisplay extends StatelessWidget {
  final GameItem item;
  final bool isDragging;

  const _ItemDisplay({
    required this.item,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDragging ? 0.9 : 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ]
            : [],
        border: Border.all(
          color: _getBorderColor(item.type),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.emoji,
            style: TextStyle(fontSize: isDragging ? 40 : 32),
          ),
          const SizedBox(height: 4),
          _buildSizeIndicator(),
        ],
      ),
    );
  }

  Widget _buildSizeIndicator() {
    final dots = item.width * item.height;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        dots,
        (_) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: _getBorderColor(item.type),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(ItemType type) {
    switch (type) {
      case ItemType.rock:
        return Colors.blue.shade400;
      case ItemType.fruit:
        return Colors.red.shade400;
      case ItemType.toy:
        return Colors.purple.shade400;
    }
  }
}