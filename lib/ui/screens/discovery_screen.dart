import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../data/element_data.dart';
import '../../models/emoji_element.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/emoji_bubble.dart';

class DiscoveryScreen extends StatelessWidget {
  final EmojiElement element;
  final CombinationOutcome? outcome;

  const DiscoveryScreen({super.key, required this.element, this.outcome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gameState = context.watch<GameState>();
    final recipes = gameState.recipesForResult(element.id);
    final followUpHints = gameState.buildDiscoveryHints(element, limit: 3);
    final seenUnlocks = <String>{};
    final unlocks = ElementData.combinations
        .where(
          (combo) => combo.element1 == element.id || combo.element2 == element.id,
        )
        .where((combo) {
          final ordered = [combo.element1, combo.element2]..sort();
          return seenUnlocks.add(
            '${ordered.first}:${ordered.last}:${combo.result}',
          );
        })
        .where((combo) => !gameState.discoveredElements.contains(combo.result))
        .take(4)
        .toList();

    final recipeUsed = outcome != null
        ? '${outcome!.ingredientA.emoji} ${outcome!.ingredientA.name} + ${outcome!.ingredientB.emoji} ${outcome!.ingredientB.name} = ${element.emoji} ${element.name}'
        : (recipes.isNotEmpty
            ? gameState.recipeText(recipes.first)
            : 'No stored formulation record.');

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
              'FORMULATION',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Element Dossier', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            Container(height: 1.5, color: AppTheme.inkBlack),
            const SizedBox(height: 18),

            // Hero Element Dossier Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              decoration: const BoxDecoration(
                color: AppTheme.inkBlack,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.accentOrange, width: 1.2),
                    ),
                    child: Text(
                      element.category.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.accentOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EmojiBubble(
                    element: element,
                    size: 110,
                    highlighted: true,
                  ).animate().scale(
                    begin: const Offset(0.85, 0.85),
                    duration: 350.ms,
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    element.name,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      color: AppTheme.offWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Recorded in the Great Alchemical Codex.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.offWhite.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 18),

            _SectionCard(
              title: 'RECIPE LOG',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeUsed,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.inkBlack,
                    ),
                  ),
                  if (recipes.length > 1) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${recipes.length} known recipes synthesize ${element.name}.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGray,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 250.ms),

            const SizedBox(height: 14),

            _SectionCard(
              title: 'PROSPECTIVE DERIVATIVES',
              child: Column(
                children: followUpHints.map((hint) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.inkBlack, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hint.badge.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentOrange,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hint.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            color: AppTheme.inkBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hint.detail,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.inkBlack.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 250.ms),

            const SizedBox(height: 14),

            _SectionCard(
              title: 'KNOWN POTENTIALS',
              child: Column(
                children: unlocks.isEmpty
                    ? [
                        Text(
                          'All immediate combinations for ${element.name} recorded. Synthesize rarer reagents to proceed.',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.darkGray),
                        ),
                      ]
                    : unlocks.map((combo) {
                        final otherId = combo.element1 == element.id
                            ? combo.element2
                            : combo.element1;
                        final other = ElementData.elements[otherId]!;
                        final result = ElementData.elements[combo.result]!;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${element.emoji} + ${other.emoji} → ${result.emoji}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    color: AppTheme.inkBlack,
                                  ),
                                ),
                              ),
                              Text(
                                result.name.toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.accentOrange,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 250.ms),

            const SizedBox(height: 22),

            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/lab');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                color: AppTheme.inkBlack,
                alignment: Alignment.center,
                child: const Text(
                  'RETURN TO LAB →',
                  style: TextStyle(
                    color: AppTheme.offWhite,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                    fontSize: 13,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          _navigateTo(context, index);
        },
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    final routeNames = ['/', '/lab', '/codex', '/profile'];
    Navigator.of(context).pushReplacementNamed(routeNames[index]);
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.inkBlack, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              letterSpacing: 1.6,
              color: AppTheme.darkGray,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
