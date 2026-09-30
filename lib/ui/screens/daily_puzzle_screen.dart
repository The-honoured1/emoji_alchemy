import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DailyPuzzleScreen extends StatelessWidget {
  const DailyPuzzleScreen({super.key});

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
              'CHRONICLE',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mutedInk,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text('Daily Formulation', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 1.5, color: AppTheme.inkBlack),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: AppTheme.inkBlack,
                    child: const Text(
                      'DAY 142 · TRIAL',
                      style: TextStyle(
                        color: AppTheme.paleText,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.stampRed, width: 1.2),
                    ),
                    child: const Text(
                      '⏱ 04:32 REMAINING',
                      style: TextStyle(
                        color: AppTheme.stampRed,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Target Card
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.inkBlack,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(width: 4, height: 16, color: AppTheme.stampRed),
                        const SizedBox(width: 8),
                        Text(
                          'TARGET DISCOVERY',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.paleText.withValues(alpha: 0.6),
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.paperWarm,
                              border: Border.all(color: AppTheme.paleText, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x66000000),
                                  blurRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text('🚂', style: TextStyle(fontSize: 54)),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Steam Train',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppTheme.paleText,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'STARTING AGENTS',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.paleText.withValues(alpha: 0.6),
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _ElementCard(icon: '🔥', label: 'FIRE'),
                        _ElementCard(icon: '💧', label: 'WATER'),
                        _ElementCard(icon: '🌍', label: 'EARTH'),
                        _ElementCard(icon: '🪵', label: 'WOOD'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.darkHairline, width: 1),
                      ),
                      child: Text(
                        'PROGRESS: 3 OF 6 STEPS UNLOCKED',
                        style: TextStyle(
                          color: AppTheme.sepiaGold,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/lab');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  color: AppTheme.stampRed,
                  alignment: Alignment.center,
                  child: const Text(
                    'COMMENCE EXPERIMENT →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElementCard extends StatelessWidget {
  final String icon;
  final String label;

  const _ElementCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.paperCream,
        border: Border.all(color: AppTheme.paleText, width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppTheme.inkBlack,
            ),
          ),
        ],
      ),
    );
  }
}
