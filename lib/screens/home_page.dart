import 'package:flutter/material.dart';
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
            title: Text("SavvyCard"),
            expandedHeight: 100,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete_forever),
        onPressed: () async {
          await DatabaseHelper.instance.purgeDatabase();
        },
      ),
    );
  }
}
