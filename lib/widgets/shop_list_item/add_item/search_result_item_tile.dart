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

  Widget _buildCircularCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: item.isInShopList
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: 2,
              ),
              color: item.isInShopList
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            child: item.isInShopList
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('${item.name}_${item.isInShopList}'),
      leading: _buildCircularCheckbox(context),
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
