import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/game_state.dart';
import '../../theme/app_theme.dart';
import '../screens/discovery_screen.dart';
import 'emoji_bubble.dart';

class DiscoveryOverlay extends StatelessWidget {
  final CombinationOutcome outcome;

  const DiscoveryOverlay({super.key, required this.outcome});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final gameState = Provider.of<GameState>(context, listen: false);
    final hintText = gameState.unlockHintFor(outcome.result);

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Text(
                'Discovered',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              // ── Element emoji ────────────────────────────────────────
              Center(
                child: Text(
                  outcome.result.emoji,
                  style: const TextStyle(fontSize: 80),
                ).animate().scale(
                  begin: const Offset(0.6, 0.6),
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                ),
              ),

              const SizedBox(height: 24),

              // ── Element name ──────────────────────────────────────────
              Center(
                child: Text(
                  outcome.result.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 40,
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ),

              const SizedBox(height: 8),

              // ── Category ─────────────────────────────────────────────
              Center(
                child: Text(
                  outcome.result.category.name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ),

              const SizedBox(height: 24),

              if (hintText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.mediumGray, width: 1),
                  ),
                  child: Text(
                    hintText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 500.ms),

              const Spacer(),

              // ── Actions ──────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => navigator.pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.mediumGray, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Continue',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
