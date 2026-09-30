import 'package:flutter/material.dart';
import '../../models/emoji_element.dart';
import '../../theme/app_theme.dart';

class EmojiBubble extends StatelessWidget {
  final EmojiElement element;
  final double size;
  final bool highlighted;
  final bool compactLabel;
  final Color? accentColor;
  final bool showLabel;

  const EmojiBubble({
    super.key,
    required this.element,
    this.size = 60,
    this.highlighted = false,
    this.compactLabel = false,
    this.accentColor,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final stamp = accentColor ?? AppTheme.stampRed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Flat fill — ink stamp on paper feel
        color: highlighted ? AppTheme.inkBlack : AppTheme.paperWarm,
        // Sharp corners — no rounded pills
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: highlighted ? stamp : AppTheme.inkBlack,
          width: highlighted ? 2.5 : 2,
        ),
        // Hard offset shadow = rubber-stamp impression
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: stamp.withValues(alpha: 0.35),
                  blurRadius: 0,
                  offset: const Offset(3, 3),
                ),
              ]
            : [
                const BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 0,
                  offset: Offset(2, 2),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            element.emoji,
            style: TextStyle(fontSize: compactLabel ? size * 0.44 : size * 0.40),
          ),
          if (showLabel && size >= 80) SizedBox(height: compactLabel ? 2 : 4),
          if (showLabel && size >= 80)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                element.name.toUpperCase(),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: compactLabel ? 8 : 9,
                  color: highlighted ? AppTheme.paleText : AppTheme.inkBlack,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFamily: 'Georgia',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
