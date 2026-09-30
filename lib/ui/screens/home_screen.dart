import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import 'collection_screen.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ────────────────────────────────────────────
                  Text(
                    'Emoji Alchemy',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Combine elements to discover new forms.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkGray,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Progress ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.mediumGray, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${gameState.discoveriesCount} / ${gameState.maxDiscoveries} discovered',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 3,
                                    color: AppTheme.mediumGray,
                                    child: FractionallySizedBox(
                                      widthFactor: gameState.discoveriesCount / gameState.maxDiscoveries,
                                      child: Container(color: AppTheme.accentOrange),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${gameState.completionPercent}%',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Action grid ───────────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ActionButton(
                        label: 'Play',
                        hint: 'Free combine',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GameScreen()),
                        ),
                      ),
                      _ActionButton(
                        label: 'Daily',
                        hint: 'Day ${gameState.dailyPuzzle?.dayNumber ?? 0}',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DailyPuzzleScreen()),
                        ),
                      ),
                      _ActionButton(
                        label: 'Codex',
                        hint: 'All elements',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CollectionScreen()),
                        ),
                      ),
                      _ActionButton(
                        label: 'Profile',
                        hint: 'Your stats',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Rank ───────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.mediumGray, width: 1),
                      color: AppTheme.lightGray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gameState.currentRank,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Day streak: ${gameState.currentStreak}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final String hint;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.mediumGray, width: 1),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

