import 'package:flutter/material.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list.dart';
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
        padding: EdgeInsets.all(16),
        children: [
          CreateShopList(),
          SizedBox(height: 16),
          ShopListListview(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          await DatabaseHelper.instance.addShopList(ShopList(name: DateTime.now().toString()));
          setState(() {});
        },
      ),
    );
  }
}
