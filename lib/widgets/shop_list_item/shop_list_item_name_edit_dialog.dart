import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListItemNameEditDialog extends ConsumerStatefulWidget {
  final ShopListItem shopListItem;

  const ShopListItemNameEditDialog({super.key, required this.shopListItem});

  @override
  ConsumerState<ShopListItemNameEditDialog> createState() =>
      _ShopListItemNameEditDialogState();
}

class _ShopListItemNameEditDialogState
    extends ConsumerState<ShopListItemNameEditDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shopListItem.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateItemName() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedItem = widget.shopListItem.copyWith(
      name: _nameController.text.trim(),
    );

    await ref
        .read(shopListItemMutationProvider.notifier)
        .updateItem(updatedItem);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveStatus = ref.watch(shopListItemMutationProvider);

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.editItemName),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.itemName,
            border: OutlineInputBorder(),
          ),
          validator: (text) => text == null || text.trim().isEmpty
              ? AppLocalizations.of(context)!.listNameCannotBeEmpty
              : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
      ),
      actions: [
        TextButton(
          onPressed: saveStatus.isLoading
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: saveStatus.isLoading ? null : _updateItemName,
          child: saveStatus.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
