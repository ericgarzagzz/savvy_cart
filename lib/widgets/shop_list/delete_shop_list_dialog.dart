import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class DeleteShopListDialog extends ConsumerStatefulWidget {
  final ShopListViewModel shopList;
  final VoidCallback? onDeleted;

  const DeleteShopListDialog({super.key, required this.shopList, this.onDeleted});

  @override
  ConsumerState<DeleteShopListDialog> createState() => _DeleteShopListDialogState();
}

class _DeleteShopListDialogState extends ConsumerState<DeleteShopListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete shop list"),
      content: Text("Are you sure you want to delete the shop list \"${widget.shopList.name}\"?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text("Confirm"),
          onPressed: () async {
            await DatabaseHelper.instance.removeShopList(widget.shopList.id ?? 0);
            // Invalidate both providers to ensure all UI components update
            ref.invalidate(shopListCollectionProvider);
            ref.read(paginatedShopListsProvider.notifier).refresh();
            if (widget.onDeleted != null) {
              widget.onDeleted!();
            }
            if (!mounted) return;
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}