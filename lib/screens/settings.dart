import 'package:flutter/material.dart';
import 'package:savvy_cart/widgets/settings/ai_settings_form.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("SavvyCart settings"),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("AI Settings", style: Theme.of(context).textTheme.titleLarge),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: AiSettingsForm(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
