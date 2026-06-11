import 'dart:ui';

class PocketShape {
  final String name;
  final List<Offset> cells;

  PocketShape({
    required this.name,
    required this.cells,
  });

  int get width {
    if (cells.isEmpty) return 0;
    int maxX = cells.map((c) => c.dx.toInt()).reduce((a, b) => a > b ? a : b);
    return maxX + 1;
  }

  int get height {
    if (cells.isEmpty) return 0;
    int maxY = cells.map((c) => c.dy.toInt()).reduce((a, b) => a > b ? a : b);
    return maxY + 1;
  }

  Offset get center {
    if (cells.isEmpty) return Offset.zero;
    double avgX = cells.map((c) => c.dx).reduce((a, b) => a + b) / cells.length;
    double avgY = cells.map((c) => c.dy).reduce((a, b) => a + b) / cells.length;
    return Offset(avgX, avgY);
  }
}