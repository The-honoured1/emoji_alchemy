import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../data/element_data.dart';
import '../../models/emoji_element.dart';
import '../../models/placed_element.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import 'discovery_overlay.dart';
import 'emoji_bubble.dart';

class _CombinePreview {
  final String dragId;
  final String targetId;
  final EmojiElement result;
  final double distance;

  const _CombinePreview({
    required this.dragId,
    required this.targetId,
    required this.result,
    required this.distance,
  });
}

class CanvasArea extends StatefulWidget {
  const CanvasArea({super.key});

  @override
  State<CanvasArea> createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> with TickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  final double _canvasSize = 5000;
  final double _bubbleSize = 82;
  final double _previewThreshold = 128;
  final double _combineThreshold = 96;

  _CombinePreview? _preview;
  String? _draggingId;

  @override
  void initState() {
    super.initState();
    _transformationController.value = Matrix4.identity();
    _transformationController.value.setTranslationRaw(
      -(_canvasSize / 2) + 220,
      -(_canvasSize / 2) + 320,
      0,
    );
  }

  void _setPreview(_CombinePreview? preview) {
    if (!mounted) return;
    final didChange =
        _preview?.dragId != preview?.dragId ||
        _preview?.targetId != preview?.targetId ||
        _preview?.result.id != preview?.result.id;
    if (didChange) {
      setState(() {
        _preview = preview;
      });
    }
  }

  _CombinePreview? _findPreview(GameState gameState, String dragId, double x, double y) {
    _CombinePreview? closest;
    final dragged = gameState.canvasElements.firstWhere((placed) => placed.id == dragId);

    for (final element in gameState.canvasElements) {
      if (element.id == dragId) continue;
      final combo = gameState.combinationForElements(dragged.element.id, element.element.id);
      if (combo == null) continue;

      final dx = (element.x + _bubbleSize / 2) - (x + _bubbleSize / 2);
      final dy = (element.y + _bubbleSize / 2) - (y + _bubbleSize / 2);
      final distance = sqrt((dx * dx) + (dy * dy));
      if (distance > _previewThreshold) continue;

      final result = ElementData.elements[combo.result]!;
      if (closest == null || distance < closest.distance) {
        closest = _CombinePreview(
          dragId: dragId,
          targetId: element.id,
          result: result,
          distance: distance,
        );
      }
    }
    return closest;
  }

  Future<void> _showDiscovery(CombinationOutcome outcome) async {
    if (!mounted || !outcome.wasNewDiscovery) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => DiscoveryOverlay(outcome: outcome),
    );
  }

  void _attemptLiveCombination(GameState gameState, String dragId, double x, double y) {
    final preview = _findPreview(gameState, dragId, x, y);
    _setPreview(preview);

    if (preview == null || preview.distance > _combineThreshold) return;

    final outcome = gameState.attemptCombination(preview.dragId, preview.targetId, x, y);
    _draggingId = null;
    _setPreview(null);

    if (outcome != null) {
      Future.microtask(() => _showDiscovery(outcome));
    }
  }

  void _handlePanUpdate(PlacedElement placed, DragUpdateDetails dragDetails) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final nextX = placed.x + (dragDetails.delta.dx / scale);
    final nextY = placed.y + (dragDetails.delta.dy / scale);
    gameState.updateElementPosition(placed.id, nextX, nextY);
    _attemptLiveCombination(gameState, placed.id, nextX, nextY);
  }

  Widget _buildPreviewBanner(ThemeData theme) {
    if (_preview == null) {
      // Idle hint — ink bar at top
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppTheme.inkBlack,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 3, height: 14, color: AppTheme.accentOrange),
            const SizedBox(width: 10),
            Text(
              'Drag elements together to mix',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.offWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      );
    }

    // Active combination preview
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.accentOrange,
        border: Border.all(color: AppTheme.inkBlack, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMBINATION READY',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Release → ${_preview!.result.name}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 160.ms).slideY(begin: -0.3, duration: 160.ms);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        final gameState = Provider.of<GameState>(context, listen: false);
        final box = context.findRenderObject() as RenderBox;
        final localOffset = box.globalToLocal(details.offset);
        final sceneOffset = _transformationController.toScene(localOffset);

        final elementId = details.data;
        if (ElementData.elements.containsKey(elementId)) {
          gameState.addToCanvas(
            ElementData.elements[elementId]!,
            sceneOffset.dx,
            sceneOffset.dy,
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        return ClipRect(
          child: Stack(
            children: [
              // ── Canvas world ─────────────────────────────────────────────
              InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: EdgeInsets.all(_canvasSize),
                minScale: 0.24,
                maxScale: 3.0,
                constrained: false,
                child: SizedBox(
                  width: _canvasSize,
                  height: _canvasSize,
                  child: Stack(
                    children: [
                      // Rice-paper background: cream + fine dot grid
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DotGridPainter(),
                        ),
                      ),
                      // Elements
                      Consumer<GameState>(
                        builder: (context, gameState, child) {
                          final orderedElements = [...gameState.canvasElements];
                          orderedElements.sort((a, b) {
                            if (a.id == _draggingId) return 1;
                            if (b.id == _draggingId) return -1;
                            return 0;
                          });
                          return Stack(
                            children: orderedElements.map((placed) {
                              final isDragging = _draggingId == placed.id;
                              final isPreviewed =
                                  _preview?.dragId == placed.id ||
                                  _preview?.targetId == placed.id;
                              final bubble = EmojiBubble(
                                element: placed.element,
                                size: _bubbleSize,
                                highlighted: isPreviewed,
                                compactLabel: true,
                              );

                              return Positioned(
                                left: placed.x,
                                top: placed.y,
                                child: GestureDetector(
                                  onPanStart: (_) {
                                    setState(() {
                                      _draggingId = placed.id;
                                    });
                                  },
                                  onPanUpdate: (d) => _handlePanUpdate(placed, d),
                                  onPanEnd: (_) {
                                    setState(() { _draggingId = null; });
                                    _setPreview(null);
                                  },
                                  onPanCancel: () {
                                    setState(() { _draggingId = null; });
                                    _setPreview(null);
                                  },
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 120),
                                    scale: isDragging ? 1.1 : (isPreviewed ? 1.04 : 1.0),
                                    child: bubble
                                        .animate(
                                          onPlay: (c) => c.repeat(reverse: true),
                                        )
                                        .moveY(
                                          begin: -1.5,
                                          end: 2.5,
                                          delay: Duration(milliseconds: (placed.element.name.length % 5) * 130),
                                          duration: (1900 + (placed.element.name.length * 35)).ms,
                                          curve: Curves.easeInOut,
                                        ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ── Preview banner ───────────────────────────────────────────
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Center(child: _buildPreviewBanner(theme)),
              ),

              // ── Help hint ────────────────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: AppTheme.inkBlack.withValues(alpha: 0.88),
                  child: Text(
                    'Pinch to zoom  ·  Drag to overlap  ·  Recipes match automatically',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.offWhite.withValues(alpha: 0.65),
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Draws a minimal grid over the background.
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppTheme.lightGray,
    );
    // Grid lines (not dots)
    final line = Paint()
      ..color = AppTheme.mediumGray
      ..strokeWidth = 0.5;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => false;
}
