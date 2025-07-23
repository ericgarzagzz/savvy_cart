import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/widgets/widgets.dart';

// Animation duration constants
const Duration _kAnimationDuration = Duration(milliseconds: 250);
const Duration _kAnimationDelay = Duration(milliseconds: 150);

class ShopListItemListtile extends ConsumerStatefulWidget {
  final ShopListItem shopListItem;

  const ShopListItemListtile({super.key, required this.shopListItem});

  @override
  ConsumerState<ShopListItemListtile> createState() =>
      _ShopListItemListtileState();
}

class _ShopListItemListtileState extends ConsumerState<ShopListItemListtile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _strikethroughAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _checkboxFillAnimation;
  late Animation<double> _checkIconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _kAnimationDuration,
      vsync: this,
    );

    _strikethroughAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _checkboxFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _checkIconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void didUpdateWidget(ShopListItemListtile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset animation when widget updates (e.g., when item moves between sections)
    if (oldWidget.shopListItem.id != widget.shopListItem.id) {
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCheckboxChanged(bool? value) async {
    if (value != null) {
      // Subtle vibration for immediate tactile feedback
      VibrationService().subtleCheckVibration();

      // Animate when checking an item from "To Buy" section
      if (!widget.shopListItem.checked && value == true) {
        _animationController.forward();
        await Future.delayed(_kAnimationDelay);
      }
      // Animate when unchecking an item from "In Cart" section
      else if (widget.shopListItem.checked && value == false) {
        _animationController.forward();
        await Future.delayed(_kAnimationDelay);
      }

      await ref
          .read(shopListItemMutationProvider.notifier)
          .setChecked(widget.shopListItem.id ?? 0, value);
    }
  }

  Widget _buildAnimatedCheckbox(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Determine animation direction based on current state
        double fillProgress, iconProgress;
        if (!widget.shopListItem.checked) {
          // Item being checked (To Buy -> In Cart)
          fillProgress = _checkboxFillAnimation.value;
          iconProgress = _checkIconAnimation.value;
        } else {
          // Item being unchecked (In Cart -> To Buy)
          fillProgress = 1.0 - _checkboxFillAnimation.value;
          iconProgress = 1.0 - _checkIconAnimation.value;
        }

        return GestureDetector(
          onTap: () => _onCheckboxChanged(!widget.shopListItem.checked),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent, // Invisible but tappable
            ),
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: fillProgress > 0.1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                  color: Color.lerp(
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary,
                    fillProgress,
                  ),
                ),
                child: iconProgress > 0.1
                    ? Transform.scale(
                        scale: iconProgress,
                        child: Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle(BuildContext context) {
    final baseTextStyle =
        Theme.of(context).textTheme.bodyLarge ?? const TextStyle();

    return AnimatedBuilder(
      animation: _strikethroughAnimation,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: widget.shopListItem.name,
                style: baseTextStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            textPainter.layout();

            return Stack(
              children: [
                // Base text without decoration
                Text(widget.shopListItem.name, style: baseTextStyle),

                // For items being checked (To Buy -> In Cart): animate strikethrough from left to right
                if (!widget.shopListItem.checked)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 1.5,
                        width:
                            _strikethroughAnimation.value * textPainter.width,
                        decoration: BoxDecoration(
                          color:
                              baseTextStyle.color ??
                              Theme.of(context).textTheme.bodyLarge?.color,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),

                // For items being unchecked (In Cart -> To Buy): show strikethrough disappearing from right to left
                if (widget.shopListItem.checked)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 1.5,
                        width:
                            textPainter.width *
                            (1.0 - _strikethroughAnimation.value),
                        decoration: BoxDecoration(
                          color:
                              baseTextStyle.color ??
                              Theme.of(context).textTheme.bodyLarge?.color,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Use primary color for both check and uncheck animations
        final primaryColor = Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.15);
        final backgroundColor = Color.lerp(
          Colors.transparent,
          primaryColor,
          _backgroundAnimation.value,
        );

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Slidable(
            key: ValueKey(widget.shopListItem.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    context.go(
                      './price-chart/${Uri.encodeComponent(widget.shopListItem.name)}',
                    );
                  },
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  icon: Icons.trending_up,
                ),
                SlidableAction(
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (ctx) => ShopListItemNameEditDialog(
                        shopListItem: widget.shopListItem,
                      ),
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Item'),
                        content: Text(
                          'Are you sure you want to delete "${widget.shopListItem.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;

                    await ref
                        .read(shopListItemMutationProvider.notifier)
                        .deleteItem(widget.shopListItem.id ?? 0);
                  },
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              leading: _buildAnimatedCheckbox(context),
              title: _buildAnimatedTitle(context),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity in noticeable container
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.shopListItem.quantity.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Total price - bolder
                    Text(
                      (widget.shopListItem.unitPrice *
                              widget.shopListItem.quantity)
                          .toStringWithLocale(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) =>
                      ShopListItemEditForm(shopListItem: widget.shopListItem),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
