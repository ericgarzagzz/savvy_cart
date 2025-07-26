import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';

class AddItemSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  const AddItemSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchOrAddNewItem,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onSubmitted: (_) => onSubmitted(),
    );
  }
}
