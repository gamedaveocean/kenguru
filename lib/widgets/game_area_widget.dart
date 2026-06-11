import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';

class GameAreaWidget extends StatefulWidget {
  final List<Offset> platformPositions;
  final List<GameItem> items;
  final int currentPlatformIndex;
  final Function(int) onPlatformTap;
  final Function(GameItem) onItemCollected;

  const GameAreaWidget({
    super.key,
    required this.platformPositions,
    required this.items,
    required this.currentPlatformIndex,
    required this.onPlatformTap,
    required this.onItemCollected,
  });

  @override
  State<GameAreaWidget> createState() => _GameAreaWidgetState();
}

class _GameAreaWidgetState extends State<GameAreaWidget>
    with TickerProviderStateMixin {
  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;
  bool _isJumping = false;
  Offset _kangarooPosition = Offset.zero;
  Offset _jumpStartPosition = Offset.zero;
  Offset _jumpEndPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _jumpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.easeOutQuad),
    );
    _jumpController.addListener(() {
      setState(() {});
    });
    _updateKangarooPosition();
  }

  @override
  void didUpdateWidget(GameAreaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPlatformIndex != oldWidget.currentPlatformIndex) {
      _animateJump();
    }
  }

  void _updateKangarooPosition() {
    if (widget.platformPositions.isNotEmpty &&
        widget.currentPlatformIndex < widget.platformPositions.length) {
      _kangarooPosition = widget.platformPositions[widget.currentPlatformIndex];
    }
  }

  void _animateJump() {
    if (widget.platformPositions.isEmpty) return;
    
    _jumpStartPosition = _kangarooPosition;
    _jumpEndPosition = widget.currentPlatformIndex < widget.platformPositions.length
        ? widget.platformPositions[widget.currentPlatformIndex]
        : _kangarooPosition;

    setState(() {
      _isJumping = true;
    });
    _jumpController.forward(from: 0).then((_) {
      setState(() {
        _isJumping = false;
      });
      _updateKangarooPosition();
    });
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final width = renderBox.size.width;
        final height = renderBox.size.height;

        for (int i = 0; i < widget.platformPositions.length; i++) {
          final pos = widget.platformPositions[i];
          final platformRect = Rect.fromCenter(
            center: Offset(pos.dx * width, pos.dy * height),
            width: 100,
            height: 40,
          );
          if (platformRect.contains(localPosition)) {
            widget.onPlatformTap(i);
            break;
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.shade200,
              Colors.lightBlue.shade400,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              children: [
                // Platforms
                ...widget.platformPositions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final pos = entry.value;
                  return Positioned(
                    left: pos.dx * width - 50,
                    top: pos.dy * height - 20,
                    child: PlatformWidget(isActive: index == widget.currentPlatformIndex),
                  );
                }),

                // Items
                ...widget.items.where((item) => !item.isCollected).map((item) {
                  return Positioned(
                    left: item.position.dx * width - 20,
                    top: item.position.dy * height - 20,
                    child: _buildItemWidget(item),
                  );
                }),

                // Kangaroo with animation
                _buildKangaroo(width, height),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildKangaroo(double width, double height) {
    double currentX, currentY;
    
    if (_isJumping) {
      final progress = _jumpAnimation.value;
      final jumpHeight = sin(progress * pi) * 80;
      currentX = _jumpStartPosition.dx * width +
          (_jumpEndPosition.dx * width - _jumpStartPosition.dx * width) * progress;
      currentY = _jumpStartPosition.dy * height +
          (_jumpEndPosition.dy * height - _jumpStartPosition.dy * height) * progress -
          jumpHeight;
    } else {
      currentX = _kangarooPosition.dx * width;
      currentY = _kangarooPosition.dy * height - 50;
    }

    return Positioned(
      left: currentX - 30,
      top: currentY - 50,
      child: const Text(
        '🦘',
        style: TextStyle(fontSize: 60),
      ),
    );
  }

  Widget _buildItemWidget(GameItem item) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item.emoji,
        style: const TextStyle(fontSize: 36),
      ),
    );
  }
}

class PlatformWidget extends StatelessWidget {
  final bool isActive;

  const PlatformWidget({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isActive
              ? [Colors.brown.shade600, Colors.brown.shade800]
              : [Colors.brown.shade400, Colors.brown.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isActive ? '✓' : '',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}