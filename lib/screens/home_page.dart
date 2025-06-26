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
      appBar: AppBar(
        title: Text("SavvyCard"),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.all(16),
        children: [
          CreateShopList(),
          Divider(height: 64, color: Colors.grey),
          ShopListListview(),
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
