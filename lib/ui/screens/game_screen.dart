import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/canvas_area.dart';
import '../widgets/collection_tray.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gameState = context.select<GameState, _LabHeaderData>((game) {
      return _LabHeaderData(
        hintsRemaining: game.hintsRemaining,
        canvasIsEmpty: game.canvasElements.isEmpty,
        discoveriesCount: game.discoveriesCount,
      );
    });
    final notifier = context.read<GameState>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back arrow
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.inkBlack, width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_back, size: 18, color: AppTheme.inkBlack),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THE LAB',
                          style: theme.textTheme.bodySmall?.copyWith(
                            letterSpacing: 2.2,
                            color: AppTheme.darkGray,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${gameState.discoveriesCount} discovered',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    children: [
                      _TopChip(
                        label: '${gameState.hintsRemaining} hints',
                        onTap: () => Navigator.of(context).pushNamed('/hints'),
                      ),
                      _TopChip(
                        label: 'Clear',
                        enabled: !gameState.canvasIsEmpty,
                        onTap: gameState.canvasIsEmpty ? null : notifier.clearCanvas,
                        danger: true,
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 220.ms),

              const SizedBox(height: 14),

              // ── Canvas ──────────────────────────────────────────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    border: Border.all(color: AppTheme.inkBlack, width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const CanvasArea(),
                ),
              ),

              const SizedBox(height: 12),
              const SizedBox(height: 92, child: CollectionTray()),
            ],
          ),
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
    final routeNames = ['/', '/lab', '/collection', '/profile'];
    Navigator.of(context).pushReplacementNamed(routeNames[index]);
  }
}

class _LabHeaderData {
  final int hintsRemaining;
  final bool canvasIsEmpty;
  final int discoveriesCount;

  const _LabHeaderData({
    required this.hintsRemaining,
    required this.canvasIsEmpty,
    required this.discoveriesCount,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _LabHeaderData &&
            hintsRemaining == other.hintsRemaining &&
            canvasIsEmpty == other.canvasIsEmpty &&
            discoveriesCount == other.discoveriesCount;
  }

  @override
  int get hashCode => Object.hash(hintsRemaining, canvasIsEmpty, discoveriesCount);
}

class _TopChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool danger;

  const _TopChip({
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = enabled && onTap != null;
    final bg = !active
        ? AppTheme.lightGray
        : danger
            ? AppTheme.accentOrange
            : AppTheme.inkBlack;
    final fg = !active
        ? AppTheme.darkGray
        : Colors.white;
    final borderColor = !active ? AppTheme.mediumGray : bg;

    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Text(
          label.toUpperCase(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: fg,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

