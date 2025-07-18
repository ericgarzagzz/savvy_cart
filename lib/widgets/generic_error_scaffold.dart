import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenericErrorScaffold extends StatelessWidget {
  final String errorMessage;
  const GenericErrorScaffold({
    super.key,
    this.errorMessage = "Something went wrong.",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
              size: 100,
            ),
            Text(errorMessage, style: Theme.of(context).textTheme.titleLarge),
            Text(
              "Please go back to the home screen and try again.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: FilledButton.icon(
                label: Text("Go to Home Page"),
                icon: Icon(Icons.home),
                onPressed: () => context.go("/"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
