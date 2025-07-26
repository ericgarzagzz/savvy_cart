import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class SearchErrorState extends StatelessWidget {
  final String error;

  const SearchErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          AppLocalizations.of(context).errorLoadingResults(error),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
