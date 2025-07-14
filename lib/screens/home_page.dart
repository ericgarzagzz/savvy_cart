import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/widgets/shop_list/create_shop_list.dart';
import 'package:savvy_cart/widgets/shop_list/shop_list_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              spacing: 8,
              children: [
                Image(
                  image: AssetImage("assets/logo_no_bg.png"),
                  width: 64,
                ),
                Text("SavvyCart",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            expandedHeight: 100,
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  context.go("./settings");
                },
              )
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CreateShopList(),
                Divider(height: 64, color: Colors.grey),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: ShopListListview(),
          )
        ],
      ),
      floatingActionButton: kDebugMode ? FloatingActionButton(
        child: Icon(Icons.delete_forever),
        onPressed: () async {
          await DatabaseHelper.instance.purgeDatabase();
        },
      ) : null,
    );
  }
}
