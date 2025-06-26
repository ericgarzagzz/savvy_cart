import 'package:flutter/material.dart';
import 'package:savvy_cart/database_helper.dart';

class ShopListListview extends StatelessWidget {
  const ShopListListview({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getShopLists(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("Loading..."));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Could not load shop lists due to an error."));
        }

        if (snapshot.data!.isEmpty) {
          return Center(child: Text("No shop list yet."));
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.map((shopList) => ListTile(
            title: Text(shopList.name),
          )).toList(),
        );
      },
    );
  }
}
