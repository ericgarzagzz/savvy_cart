import 'package:flutter/material.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:savvy_cart/widgets/shop_list/shop_list_listtile.dart';

class ShopListListview extends StatelessWidget {
  const ShopListListview({super.key});

  Future<List<Map<String, dynamic>>> _prepareShopListData(List<ShopList> shopLists) async {
    final List<Map<String, dynamic>> processedList = [];
    for (var shopList in shopLists) {
      final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
      processedList.add({'shopList': shopList, 'checkedAmount': checkedAmount});
    }
    return processedList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shop lists", style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 16),
        FutureBuilder(
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

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _prepareShopListData(snapshot.data!),
              builder: (context, processedDataSnapshot) {
                if (processedDataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Processing shop lists..."));
                }
                if (processedDataSnapshot.hasError) {
                  return Center(child: Text("Error processing shop list data: ${processedDataSnapshot.error}"));
                }
                if (!processedDataSnapshot.hasData || processedDataSnapshot.data!.isEmpty) {
                  return Center(child: Text("No processed data."));
                }

                return ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: processedDataSnapshot.data!.map((dataItem) {
                    return ShopListListTile(
                      shopList: dataItem['shopList'],
                      checkedAmount: dataItem['checkedAmount'],
                    );
                  }).toList(),
                );
              },
            );
          },
        )
      ],
    );
  }
}
