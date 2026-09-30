import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../screens/discovery_screen.dart';
import 'emoji_bubble.dart';

class DiscoveryOverlay extends StatelessWidget {
  final CombinationOutcome outcome;

  const DiscoveryOverlay({super.key, required this.outcome});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final gameState = Provider.of<GameState>(context, listen: false);
    final hintText = gameState.unlockHintFor(outcome.result);
    final recipeText =
        '${outcome.ingredientA.emoji} ${outcome.ingredientA.name}  +  '
        '${outcome.ingredientB.emoji} ${outcome.ingredientB.name}';

    return Scaffold(
      backgroundColor: AppTheme.inkBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── "NEW DISCOVERY" stamp ─────────────────────────────────
              Row(
                children: [
                  Container(width: 4, height: 22, color: AppTheme.stampRed),
                  const SizedBox(width: 12),
                  Text(
                    'NEW DISCOVERY',
                    style: const TextStyle(
                      color: AppTheme.stampRed,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.5,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              )
                  .animate()
                  .slideX(begin: -0.4, duration: 400.ms, curve: Curves.easeOut)
                  .fadeIn(),

              const Spacer(),

              // ── Giant emoji stamp ─────────────────────────────────────
              Center(
                child: EmojiBubble(
                  element: outcome.result,
                  size: 160,
                  highlighted: true,
                ).animate().scale(
                  begin: const Offset(0.1, 0.1),
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
              ),

              const SizedBox(height: 28),

              // ── Element name ──────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      outcome.result.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.paleText,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Georgia',
                        letterSpacing: 1.2,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 2,
                      width: 40,
                      color: AppTheme.stampRed,
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.4),
              ),

              const SizedBox(height: 12),

              // ── Category tag ──────────────────────────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.stampRed, width: 1.5),
                  ),
                  child: Text(
                    outcome.result.category.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.stampRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ).animate().fadeIn(delay: 650.ms),
              ),

              const SizedBox(height: 32),

              // ── Recipe ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.darkHairline, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      recipeText,
                      style: const TextStyle(
                        color: AppTheme.paleText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Georgia',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '= ${outcome.result.emoji} ${outcome.result.name}',
                      style: const TextStyle(
                        color: AppTheme.stampRed,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Georgia',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (hintText.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 14),
                        height: 1,
                        color: AppTheme.darkHairline,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        hintText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.paleText.withValues(alpha: 0.55),
                          fontSize: 14,
                          fontFamily: 'Georgia',
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(delay: 900.ms),

              const Spacer(),

              // ── Actions ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => navigator.pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.darkHairline, width: 1.2),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            color: AppTheme.paleText,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigator.pop();
                        Future.microtask(() {
                          navigator.push(
                            MaterialPageRoute(
                              builder: (_) => DiscoveryScreen(
                                element: outcome.result,
                                outcome: outcome,
                              ),
                            ),
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        color: AppTheme.stampRed,
                        alignment: Alignment.center,
                        child: const Text(
                          'VIEW →',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
