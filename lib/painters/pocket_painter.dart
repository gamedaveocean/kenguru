import 'package:flutter/material.dart';
import '../models/models.dart';

class PocketPainter extends CustomPainter {
  final PocketShape shape;
  final Set<Offset> occupiedCells;
  final Offset? highlightedCell;

  PocketPainter({
    required this.shape,
    required this.occupiedCells,
    this.highlightedCell,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (shape.cells.isEmpty) return;

    final cellWidth = size.width / shape.width;
    final cellHeight = size.height / shape.height;
    final cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

    // Background
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw each cell
    for (int i = 0; i < shape.cells.length; i++) {
      final cell = shape.cells[i];
      final isOccupied = occupiedCells.contains(cell);
      
      final cellPaint = Paint()
        ..color = isOccupied ? Colors.green.shade200 : Colors.white
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final rect = Rect.fromLTWH(
        cell.dx * cellSize,
        cell.dy * cellSize,
        cellSize,
        cellSize,
      );
      
      canvas.drawRect(rect, cellPaint);
      canvas.drawRect(rect, borderPaint);

      // Highlight valid drop zone
      if (highlightedCell != null && cell == highlightedCell && !isOccupied) {
        final highlightPaint = Paint()
          ..color = Colors.green.withOpacity(0.5)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PocketPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.occupiedCells != occupiedCells ||
        oldDelegate.highlightedCell != highlightedCell;
  }
}