import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import 'codex_screen.dart';
import 'game_screen.dart';
import 'daily_puzzle_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Masthead ─────────────────────────────────────────────
                  Text(
                    'THE GREAT LAB',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mutedInk,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displayLarge,
                      children: const [
                        TextSpan(text: 'Emoji\n'),
                        TextSpan(
                          text: 'Alchemy',
                          style: TextStyle(color: AppTheme.stampRed),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),
                  // thin rule
                  Container(height: 1, color: AppTheme.inkBlack),
                  const SizedBox(height: 28),

                  // ── Daily card ───────────────────────────────────────────
                  _DailyCard(accent: AppTheme.stampRed, theme: theme, context: context)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),

                  const SizedBox(height: 20),

                  // ── Progress band ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.inkBlack, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chris_Alch · Sage',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              // Ink-bar progress
                              Stack(
                                children: [
                                  Container(height: 6, color: AppTheme.paperWarm),
                                  FractionallySizedBox(
                                    widthFactor: gameState.discoveriesCount / gameState.maxDiscoveries,
                                    child: Container(height: 6, color: AppTheme.inkBlack),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${gameState.discoveriesCount} / ${gameState.maxDiscoveries} discovered',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${gameState.completionPercent}%',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 42,
                            color: AppTheme.stampRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 20),

                  // ── Quick-action tiles ────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          label: 'SANDBOX',
                          sub: 'Free play',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const GameScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionTile(
                          label: 'DAILY',
                          sub: 'Day 142',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const DailyPuzzleScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          label: 'CODEX',
                          sub: 'All elements',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CodexScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionTile(
                          label: 'PROFILE',
                          sub: 'Your stats',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ProfileScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          _navigateTo(context, index);
        },
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    final routes = [
      () => const HomeScreen(),
      () => const GameScreen(),
      () => const CodexScreen(),
      () => const ProfileScreen(),
    ];
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => routes[index]()),
    );
  }
}

class _DailyCard extends StatelessWidget {
  final Color accent;
  final ThemeData theme;
  final BuildContext context;

  const _DailyCard({required this.accent, required this.theme, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DailyPuzzleScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.inkBlack,
          boxShadow: [
            BoxShadow(
              color: AppTheme.stampRed.withValues(alpha: 0.3),
              blurRadius: 0,
              offset: const Offset(6, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative corner accent
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.stampRed, width: 3),
                    left: BorderSide(color: AppTheme.stampRed, width: 3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TODAY',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.paleText.withValues(alpha: 0.5),
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Daily Trial',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppTheme.paleText,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.stampRed, width: 2),
                          color: AppTheme.stampRed.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          '✨ NEW',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.stampRed,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A fresh challenge awaits each sunrise. Discover new elements through guided synthesis.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.paleText.withValues(alpha: 0.65),
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      color: AppTheme.stampRed,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'BEGIN',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final String sub;
  final VoidCallback onTap;

  const _ActionTile({required this.label, required this.sub, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.inkBlack, width: 1.5),
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.inkBlack,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontSize: 11,
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppTheme.inkBlack, size: 12),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              sub,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mutedInk,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
