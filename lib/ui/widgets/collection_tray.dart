import 'package:flutter/material.dart';
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
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        border: Border(
          top: BorderSide(color: AppTheme.inkBlack, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: discoveredIds.length,
        itemBuilder: (context, index) {
          final element = ElementData.elements[discoveredIds[index]]!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Draggable<String>(
              data: element.id,
              feedback: Material(
                color: Colors.transparent,
                child: EmojiBubble(
                  element: element,
                  size: 64,
                  highlighted: false,
                  showLabel: false,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: EmojiBubble(
                  element: element,
                  size: 60,
                  showLabel: false,
                ),
              ),
              child: EmojiBubble(
                element: element,
                size: 60,
                showLabel: false,
              ),
            ),
          );
        },
      ),
    );
  }
}

