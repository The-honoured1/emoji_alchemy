import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/emoji_item.dart';

class EmojiWidget extends StatelessWidget {
  final EmojiItem item;
  final VoidCallback? onTap;
  final bool isDraggable;

  const EmojiWidget({
    Key? key,
    required this.item,
    this.onTap,
    this.isDraggable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          item.emoji,
          style: const TextStyle(fontSize: 34),
        ),
      ),
    )
        .animate()
        .scale(
          duration: 400.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0.5, 0.5),
        )
        .fadeIn(duration: 200.ms);

    if (!isDraggable) return content;

    return content;
  }
}
