import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
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
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _reverseColorAnimation;

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

    _colorAnimation =
        ColorTween(
          begin: Colors.transparent,
          end: Colors.green.withValues(alpha: 0.2),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _reverseColorAnimation =
        ColorTween(
          begin: Colors.transparent,
          end: Colors.blue.withValues(alpha: 0.2),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
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
        // Determine which color animation to use based on current state
        Color? backgroundColor;
        if (!widget.shopListItem.checked) {
          // Item is in "To Buy" section, use green when checking
          backgroundColor = _colorAnimation.value;
        } else {
          // Item is in "In Cart" section, use blue when unchecking
          backgroundColor = _reverseColorAnimation.value;
        }

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
              leading: GestureDetector(
                onTap: () => _onCheckboxChanged(!widget.shopListItem.checked),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.shopListItem.checked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                    color: widget.shopListItem.checked
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: widget.shopListItem.checked
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        )
                      : null,
                ),
              ),
              title: _buildAnimatedTitle(context),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(
                    widget.shopListItem.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    (widget.shopListItem.unitPrice *
                            widget.shopListItem.quantity)
                        .toStringWithLocale(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
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
