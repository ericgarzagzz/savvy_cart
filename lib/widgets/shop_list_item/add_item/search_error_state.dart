import 'package:flutter/material.dart';

class SearchErrorState extends StatelessWidget {
  final String error;

  const SearchErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error loading results: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
