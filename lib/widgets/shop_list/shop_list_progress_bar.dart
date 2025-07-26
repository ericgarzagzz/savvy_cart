import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListProgressBar extends ConsumerStatefulWidget {
  final int shopListId;

  const ShopListProgressBar({super.key, required this.shopListId});

  @override
  ConsumerState<ShopListProgressBar> createState() =>
      _ShopListProgressBarState();
}

class _ShopListProgressBarState extends ConsumerState<ShopListProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress(double newProgress) {
    if (newProgress != _previousProgress) {
      _previousProgress = newProgress;
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: newProgress,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOutCubic,
            ),
          );
      _animationController.reset();
      _animationController.forward();
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.33) {
      // Red to Orange (0% - 33%)
      return Color.lerp(
        Colors.red.shade400,
        Colors.orange.shade400,
        progress * 3,
      )!;
    } else if (progress < 0.66) {
      // Orange to Yellow (33% - 66%)
      return Color.lerp(
        Colors.orange.shade400,
        Colors.amber.shade400,
        (progress - 0.33) * 3,
      )!;
    } else {
      // Yellow to Green (66% - 100%)
      return Color.lerp(
        Colors.amber.shade400,
        Colors.green.shade400,
        (progress - 0.66) * 3,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final toBuyItemsAsync = ref.watch(
      shopListItemsProvider((widget.shopListId, false)),
    );
    final inCartItemsAsync = ref.watch(
      shopListItemsProvider((widget.shopListId, true)),
    );

    return toBuyItemsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (toBuyItems) {
        return inCartItemsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (inCartItems) {
            final checkedCount = inCartItems.length;
            final totalCount = toBuyItems.length + inCartItems.length;

            if (totalCount == 0) {
              return const SizedBox.shrink();
            }

            final progress = checkedCount / totalCount;

            // Update animation when progress changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateProgress(progress);
            });

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Labels above the progress bar
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      final animatedProgress = _progressAnimation.value;
                      final progressColor = _getProgressColor(animatedProgress);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.itemsCompleted(checkedCount, totalCount),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            '${(animatedProgress * 100).round()}%',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: progressColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        final animatedProgress = _progressAnimation.value;
                        final progressColor = _getProgressColor(
                          animatedProgress,
                        );

                        return Stack(
                          children: [
                            // Background track - always visible
                            Container(
                              width: double.infinity,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ),
                            ),
                            // Progress fill with gradient
                            if (animatedProgress > 0)
                              FractionallySizedBox(
                                widthFactor: animatedProgress,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        progressColor.withValues(alpha: 0.7),
                                        progressColor,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: progressColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
