import 'package:flutter/material.dart';

class SearchResultItemTile extends StatelessWidget {
  final dynamic item;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SearchResultItemTile({
    super.key,
    required this.item,
    required this.isLoading,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('${item.name}_${item.isInShopList}'),
      leading: Checkbox(
        value: item.isInShopList,
        onChanged: isLoading ? null : (_) => onTap(),
      ),
      title: Text(item.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        color: Theme.of(context).colorScheme.error,
        onPressed: onRemove,
      ),
      onTap: isLoading ? null : onTap,
      enabled: !isLoading,
    );
  }
}
