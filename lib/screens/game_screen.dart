import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/game_state.dart';
import '../widgets/game_area_widget.dart';
import '../widgets/pocket_widget.dart';
import '../data/levels.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = context.read<GameState>();
      if (gameLevels.isNotEmpty) {
        gameState.initLevel(gameLevels[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🦘 Кенгуру-головоломка'),
        centerTitle: true,
        backgroundColor: Colors.brown.shade400,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          if (gameLevels.isEmpty || gameState.currentLevelIndex >= gameLevels.length) {
            return const Center(
              child: Text('Поздравляем! Все уровни пройдены! 🎉'),
            );
          }

          final currentLevel = gameLevels[gameState.currentLevelIndex];

          return Column(
            children: [
              // Level indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.orange.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Уровень ${currentLevel.id}: ${currentLevel.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildPhaseIndicator(gameState.phase),
                  ],
                ),
              ),
              // Game area (60%)
              Expanded(
                flex: 6,
                child: GameAreaWidget(
                  platformPositions: currentLevel.platformPositions,
                  items: gameState.levelItems,
                  currentPlatformIndex: gameState.currentPlatformIndex,
                  onPlatformTap: (index) {
                    gameState.setPlatformIndex(index);
                    // Check for item collection
                    _checkItemCollection(context, gameState, currentLevel);
                  },
                  onItemCollected: (item) {
                    gameState.collectItem(item);
                  },
                ),
              ),
              // Divider with instruction
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade200,
                child: Text(
                  gameState.phase == GamePhase.collecting
                      ? 'Нажмите на платформу, чтобы кенгуру прыгнул туда'
                      : 'Перетащите предметы в карман',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              // Pocket area (40%)
              Expanded(
                flex: 4,
                child: gameState.phase == GamePhase.placing || gameState.phase == GamePhase.completed
                    ? PocketWidget(
                        shape: currentLevel.pocketShape,
                        placedItems: gameState.placedItems,
                        collectedItems: gameState.collectedItems,
                        onItemPlaced: (item, position) {
                          gameState.placeItem(item, position);
                          if (gameState.checkCompletion(currentLevel.pocketShape)) {
                            _showCompletionDialog(context, gameState);
                          }
                        },
                        onShapeFilled: () {
                          if (gameState.checkCompletion(currentLevel.pocketShape)) {
                            _showCompletionDialog(context, gameState);
                          }
                        },
                      )
                    : _buildWaitingPocket(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhaseIndicator(GamePhase phase) {
    IconData icon;
    Color color;
    String text;

    switch (phase) {
      case GamePhase.collecting:
        icon = Icons.hiking;
        color = Colors.green;
        text = 'Сбор';
        break;
      case GamePhase.placing:
        icon = Icons.extension;
        color = Colors.orange;
        text = 'Размещение';
        break;
      case GamePhase.completed:
        icon = Icons.check_circle;
        color = Colors.blue;
        text = 'Готово!';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWaitingPocket() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Соберите все предметы\nчтобы открыть карман',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _checkItemCollection(BuildContext context, GameState gameState, Level level) {
    if (gameState.phase != GamePhase.collecting) return;

    for (final item in gameState.levelItems) {
      if (!item.isCollected) {
        final platforms = level.platformPositions;
        if (gameState.isItemNearKangaroo(item, platforms, gameState.currentPlatformIndex)) {
          gameState.collectItem(item);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Собран ${item.emoji}!'),
              duration: const Duration(milliseconds: 500),
            ),
          );
          break;
        }
      }
    }
  }

  void _showCompletionDialog(BuildContext context, GameState gameState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 Поздравляем!'),
          ],
        ),
        content: const Text('Вы успешно заполнили карман!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (gameState.currentLevelIndex + 1 < gameLevels.length) {
                gameState.nextLevel();
                gameState.initLevel(gameLevels[gameState.currentLevelIndex]);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('🏆 Все уровни пройдены!'),
                    content: const Text('Вы настоящий мастер головоломок!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Restart from level 1
                          gameState.initLevel(gameLevels[0]);
                        },
                        child: const Text('Играть снова'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text(
              gameState.currentLevelIndex + 1 < gameLevels.length
                  ? 'Следующий уровень →'
                  : 'Завершить',
            ),
          ),
        ],
      ),
    );
  }
}