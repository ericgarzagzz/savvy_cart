import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class GenericErrorScaffold extends StatelessWidget {
  final String errorMessage;
  const GenericErrorScaffold({super.key, this.errorMessage = ""});

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
            Text(
              errorMessage.isEmpty
                  ? AppLocalizations.of(context).somethingWentWrong
                  : errorMessage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              AppLocalizations.of(context).pleaseGoBackToHomeScreen,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: FilledButton.icon(
                label: Text(AppLocalizations.of(context).goToHomePage),
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
