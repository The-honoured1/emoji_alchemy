import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/element_data.dart';
import '../../models/element_category.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              'RECORDS',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Alchemist Profile', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          final categories = [
            ElementCategory.nature,
            ElementCategory.technology,
            ElementCategory.magic,
            ElementCategory.space,
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 1.5, color: AppTheme.inkBlack),
                const SizedBox(height: 20),

                // Alchemist Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.inkBlack,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppTheme.accentOrange,
                          border: Border.all(color: AppTheme.offWhite, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '錬',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chris_Alch',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.offWhite,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'RANK · SAGE MASTER',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.mediumGray, width: 1.2),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.offWhite.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Grid
                Row(
                  children: [
                    _StatCard(title: 'DISCOVERIES', value: '${gameState.discoveriesCount}'),
                    const SizedBox(width: 10),
                    _StatCard(title: 'COMPLETION', value: '${gameState.completionPercent}%'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _StatCard(title: 'DAY STREAK', value: '${gameState.currentStreak}'),
                    const SizedBox(width: 10),
                    _StatCard(title: 'RAREST ELEMENT', value: gameState.rarestElement.emoji),
                  ],
                ),

                const SizedBox(height: 24),
                Text(
                  'CATEGORY DISCOVERY',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkGray,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                ...categories.map((category) {
                  final discovered = gameState.discoveredByCategory[category] ?? 0;
                  final total = ElementData.elements.values
                      .where((element) => element.category == category)
                      .length;
                  final percent = total == 0 ? 0.0 : discovered / total;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.inkBlack, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _categoryLabel(category).toUpperCase(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.inkBlack,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              '$discovered / $total (${(percent * 100).round()}%)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(height: 6, color: AppTheme.lightGray),
                            FractionallySizedBox(
                              widthFactor: percent,
                              child: Container(height: 6, color: AppTheme.inkBlack),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),
                Text(
                  'WEEKLY ARCHIVE',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkGray,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: 'MTWTFSS'.split('').asMap().entries.map((entry) {
                    final day = entry.value;
                    final isHighlighted = entry.key >= 5;
                    return Container(
                      width: 40,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isHighlighted ? AppTheme.accentOrange : Colors.transparent,
                        border: Border.all(
                          color: isHighlighted ? AppTheme.accentOrange : AppTheme.inkBlack,
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isHighlighted ? Colors.white : AppTheme.inkBlack,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          fontFamily: 'system',
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          _navigateTo(context, index);
        },
      ),
    );
  }

  String _categoryLabel(ElementCategory category) {
    switch (category) {
      case ElementCategory.base:
        return 'Base';
      case ElementCategory.nature:
        return 'Nature';
      case ElementCategory.weather:
        return 'Weather';
      case ElementCategory.animals:
        return 'Animals';
      case ElementCategory.human:
        return 'Human';
      case ElementCategory.technology:
        return 'Technology';
      case ElementCategory.magic:
        return 'Magic';
      case ElementCategory.food:
        return 'Food';
      case ElementCategory.space:
        return 'Space';
      case ElementCategory.mythology:
        return 'Mythology';
      case ElementCategory.other:
        return 'Other';
    }
  }

  void _navigateTo(BuildContext context, int index) {
    final routeNames = ['/', '/lab', '/collection', '/profile'];
    Navigator.of(context).pushReplacementNamed(routeNames[index]);
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.inkBlack, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
                letterSpacing: 1.1,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.inkBlack,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

