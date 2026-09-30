import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';

class HintScreen extends StatelessWidget {
  const HintScreen({super.key});

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
              'ORACLE',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mutedInk,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Alchemical Guidance', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          final suggestions = gameState.hintSuggestions;
          final activeHint = gameState.activeHint;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Container(height: 1.5, color: AppTheme.inkBlack),
              const SizedBox(height: 20),

              // Hint Tokens Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.inkBlack,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HINT TOKENS',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.paleText.withValues(alpha: 0.6),
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${gameState.hintsRemaining}',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: AppTheme.paleText,
                            fontSize: 40,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: gameState.hintsRemaining > 0
                              ? () {
                                  final hint = gameState.useHint();
                                  if (hint == null) return;
                                  showModalBottomSheet<void>(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => _HintRevealSheet(hint: hint),
                                  );
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            color: gameState.hintsRemaining > 0
                                ? AppTheme.stampRed
                                : AppTheme.darkHairline,
                            child: Text(
                              'REVEAL HINT →',
                              style: TextStyle(
                                color: gameState.hintsRemaining > 0
                                    ? Colors.white
                                    : AppTheme.paleText.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                fontSize: 12,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Consult the ancient manuscript to unlock a viable synthesis path.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.paleText.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 250.ms),

              if (activeHint != null) ...[
                const SizedBox(height: 18),
                _HintCard(hint: activeHint, emphasized: true)
                    .animate()
                    .fadeIn(duration: 200.ms),
              ],

              const SizedBox(height: 24),
              Text(
                'SUGGESTED PATHWAYS',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.mutedInk,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ...suggestions.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _HintCard(
                    hint: entry.value,
                    emphasized: entry.key == 0 && activeHint == null,
                  ).animate().fadeIn(
                    delay: Duration(milliseconds: 70 * entry.key),
                    duration: 200.ms,
                  ),
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          final routeNames = ['/', '/lab', '/codex', '/profile'];
          Navigator.of(context).pushReplacementNamed(routeNames[index]);
        },
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  final LabHint hint;
  final bool emphasized;

  const _HintCard({required this.hint, this.emphasized = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasized ? AppTheme.paperWarm : Colors.transparent,
        border: Border.all(
          color: emphasized ? AppTheme.stampRed : AppTheme.inkBlack,
          width: emphasized ? 1.8 : 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emphasized) ...[
                Container(width: 4, height: 14, color: AppTheme.stampRed),
                const SizedBox(width: 8),
              ],
              Text(
                hint.badge.toUpperCase(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: emphasized ? AppTheme.stampRed : AppTheme.mutedInk,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hint.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.inkBlack,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hint.detail,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.inkBlack,
              fontSize: 14,
            ),
          ),
          if (hint.recipe != null) ...[
            const SizedBox(height: 10),
            Text(
              hint.recipe!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.stampRed,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HintRevealSheet extends StatelessWidget {
  final LabHint hint;

  const _HintRevealSheet({required this.hint});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.inkBlack,
            border: Border.all(color: AppTheme.stampRed, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hint.badge.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.stampRed,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                hint.title,
                style: const TextStyle(
                  color: AppTheme.paleText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                hint.detail,
                style: TextStyle(
                  color: AppTheme.paleText.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontFamily: 'Georgia',
                ),
              ),
              if (hint.recipe != null) ...[
                const SizedBox(height: 14),
                Text(
                  hint.recipe!,
                  style: const TextStyle(
                    color: AppTheme.sepiaGold,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
              const SizedBox(height: 22),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: AppTheme.stampRed,
                  alignment: Alignment.center,
                  child: const Text(
                    'DISMISS ADVICE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      fontSize: 13,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
