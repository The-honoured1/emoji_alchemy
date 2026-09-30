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
                  _DailyCard(accent: AppTheme.stampRed, theme: theme, context: context),

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
        MaterialPageRoute(builder: (_) => const GameScreen()),
      ),
      child: Container(
        decoration: const BoxDecoration(color: AppTheme.inkBlack),
        child: Stack(
          children: [
            // Decorative side stamp line
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: AppTheme.stampRed),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TODAY · DAY 142',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.paleText.withValues(alpha: 0.55),
                          letterSpacing: 1.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.stampRed, width: 1.2),
                        ),
                        child: Text(
                          '3 HINTS',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.stampRed,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Steam Engine Run',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.paleText,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reach 🔥 + 💧 in 6 steps',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.paleText.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      color: AppTheme.stampRed,
                      child: Text(
                        'START →',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.inkBlack, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.inkBlack,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mutedInk,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
