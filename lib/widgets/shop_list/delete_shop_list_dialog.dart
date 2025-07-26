import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class DeleteShopListDialog extends ConsumerStatefulWidget {
  final ShopListViewModel shopList;
  final VoidCallback? onDeleted;

  const DeleteShopListDialog({
    super.key,
    required this.shopList,
    this.onDeleted,
  });

  @override
  ConsumerState<DeleteShopListDialog> createState() =>
      _DeleteShopListDialogState();
}

class _DeleteShopListDialogState extends ConsumerState<DeleteShopListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.deleteShopList),
      content: Text(
        AppLocalizations.of(
          context,
        )!.confirmDeleteShopList(widget.shopList.name),
      ),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
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
          child: Text(AppLocalizations.of(context)!.confirm),
          onPressed: () async {
            await ref
                .read(shopListMutationProvider.notifier)
                .removeShopList(widget.shopList.id ?? 0);
            if (widget.onDeleted != null) {
              widget.onDeleted!();
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
