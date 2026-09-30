import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/element_category.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/emoji_bubble.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  ElementCategory? selectedCategory;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'ALL',       'category': null},
    {'label': 'NATURE',    'category': ElementCategory.nature},
    {'label': 'WEATHER',   'category': ElementCategory.weather},
    {'label': 'ANIMALS',   'category': ElementCategory.animals},
    {'label': 'HUMAN',     'category': ElementCategory.human},
    {'label': 'TECH',      'category': ElementCategory.technology},
    {'label': 'MAGIC',     'category': ElementCategory.magic},
    {'label': 'FOOD',      'category': ElementCategory.food},
    {'label': 'SPACE',     'category': ElementCategory.space},
    {'label': 'MYTH',      'category': ElementCategory.mythology},
    {'label': 'OTHER',     'category': ElementCategory.other},
  ];

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
              'COLLECTION',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Your discoveries', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          final discovered = gameState.discoveredElementList
              .where((e) => selectedCategory == null || e.category == selectedCategory)
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Divider ────────────────────────────────────────────────
              Container(height: 1.5, color: AppTheme.inkBlack),

              // ── Stats bar ──────────────────────────────────────────────
              Container(
                color: AppTheme.inkBlack,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${gameState.discoveriesCount} discovered',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.offWhite.withValues(alpha: 0.6),
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '${gameState.discoveriesCount} / ${gameState.maxDiscoveries}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Filters ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _filters.map((filter) {
                    final isSelected = selectedCategory == filter['category'];
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = filter['category']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.inkBlack : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppTheme.inkBlack : AppTheme.mediumGray,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          filter['label'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected ? AppTheme.offWhite : AppTheme.darkGray,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 14),

              // ── Grid ───────────────────────────────────────────────────
              Expanded(
                child: discovered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 48,
                              height: 1.5,
                              color: AppTheme.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No discoveries yet.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.count(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        crossAxisCount: 3,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: discovered.map((element) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.inkBlack,
                              border: Border.all(color: AppTheme.mediumGray, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.inkBlack.withValues(alpha: 0.12),
                                  blurRadius: 0,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmojiBubble(element: element, size: 68),
                                const SizedBox(height: 10),
                                Text(
                                  element.name.toUpperCase(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.offWhite.withValues(alpha: 0.75),
                                    fontSize: 9,
                                    letterSpacing: 0.8,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
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

