import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/emoji_bubble.dart';

class DailyPuzzleScreen extends StatefulWidget {
  const DailyPuzzleScreen({super.key});

  @override
  State<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends State<DailyPuzzleScreen> with TickerProviderStateMixin {
  late AnimationController _timerController;
  String _timeDisplay = '--:--';

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _updateTimer();
  }

  void _updateTimer() {
    final gameState = context.read<GameState>();
    final remaining = gameState.dailyPuzzleTimeRemaining;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    setState(() {
      _timeDisplay = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.inkBlack, width: 1.5),
              ),
              child: const Icon(Icons.arrow_back, size: 16, color: AppTheme.inkBlack),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHRONICLE',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mutedInk,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Daily Formulation', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, _) {
          final puzzle = gameState.dailyPuzzle;
          if (puzzle == null) {
            return Center(
              child: Text('Loading puzzle...', style: theme.textTheme.bodyMedium),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: 1.5, color: AppTheme.inkBlack),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        color: AppTheme.inkBlack,
                        child: Text(
                          'DAY ${puzzle.dayNumber} · TRIAL',
                          style: const TextStyle(
                            color: AppTheme.paleText,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _timerController,
                        builder: (context, child) {
                          _updateTimer();
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: puzzle.completed ? AppTheme.inkBlack : AppTheme.stampRed,
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              puzzle.completed ? '✓ COMPLETE' : '⏱ $_timeDisplay REMAINING',
                              style: TextStyle(
                                color: puzzle.completed ? AppTheme.inkBlack : AppTheme.stampRed,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Target Card
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.inkBlack,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(width: 4, height: 16, color: AppTheme.stampRed),
                            const SizedBox(width: 8),
                            Text(
                              'TARGET DISCOVERY',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.paleText.withValues(alpha: 0.6),
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              EmojiBubble(
                                element: puzzle.target,
                                size: 100,
                                highlighted: puzzle.completed,
                              ).animate().scale(
                                begin: const Offset(0.85, 0.85),
                                duration: 350.ms,
                                curve: Curves.easeOutBack,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                puzzle.target.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.paleText,
                                  fontSize: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'STARTING AGENTS',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.paleText.withValues(alpha: 0.6),
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: puzzle.startingElements
                              .map((element) => _ElementCard(element: element))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.darkHairline, width: 1),
                          ),
                          child: Text(
                            puzzle.completed ? '✓ PUZZLE SOLVED' : 'PROGRESS: Combine to reach target',
                            style: TextStyle(
                              color: puzzle.completed ? AppTheme.inkBlack : AppTheme.sepiaGold,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  if (!puzzle.completed)
                    GestureDetector(
                      onTap: () {
                        // Navigate to lab with daily puzzle mode
                        Navigator.of(context).pushNamed('/lab');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        color: AppTheme.stampRed,
                        alignment: Alignment.center,
                        child: const Text(
                          'COMMENCE EXPERIMENT →',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        gameState.resetDailyPuzzle();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        color: AppTheme.inkBlack,
                        alignment: Alignment.center,
                        child: const Text(
                          'RESET & TRY AGAIN',
                          style: TextStyle(
                            color: AppTheme.paleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ElementCard extends StatelessWidget {
  final dynamic element; // EmojiElement type

  const _ElementCard({required this.element});

  @override
  Widget build(BuildContext context) {
    return EmojiBubble(
      element: element,
      size: 72,
      compactLabel: true,
    );
  }
}
