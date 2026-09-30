import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/game_state.dart';
import '../../data/element_data.dart';
import '../../theme/app_theme.dart';
import 'emoji_bubble.dart';

class CollectionTray extends StatelessWidget {
  const CollectionTray({super.key});

  @override
  Widget build(BuildContext context) {
    final discoveredIds = context.select<GameState, List<String>>((gameState) {
      final ids = gameState.discoveredElements.toList();
      ids.sort((a, b) {
        final elementA = ElementData.elements[a]!;
        final elementB = ElementData.elements[b]!;
        final categoryCompare = elementA.category.index.compareTo(elementB.category.index);
        if (categoryCompare != 0) return categoryCompare;
        return elementA.name.compareTo(elementB.name);
      });
      return ids;
    });

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.paperCream,
        border: Border(
          top: BorderSide(color: AppTheme.inkBlack, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: discoveredIds.length,
        itemBuilder: (context, index) {
          final element = ElementData.elements[discoveredIds[index]]!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Draggable<String>(
              data: element.id,
              feedback: Material(
                color: Colors.transparent,
                child: EmojiBubble(
                  element: element,
                  size: 72,
                  highlighted: true,
                  compactLabel: true,
                  showLabel: false,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: EmojiBubble(
                  element: element,
                  size: 68,
                  compactLabel: true,
                  showLabel: false,
                ),
              ),
              child: EmojiBubble(
                element: element,
                size: 68,
                compactLabel: true,
                showLabel: false,
              ),
            ).animate().fadeIn(
              delay: Duration(milliseconds: (index % 8) * 40),
              duration: 200.ms,
            ),
          );
        },
      ),
    );
  }
}
