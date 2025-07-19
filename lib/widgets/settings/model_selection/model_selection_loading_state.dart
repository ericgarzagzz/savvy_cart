import 'package:flutter/material.dart';

class ModelSelectionLoadingState extends StatelessWidget {
  const ModelSelectionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading available models...'),
        ],
      ),
    );
  }
}
