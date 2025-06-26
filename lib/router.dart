import 'package:go_router/go_router.dart';
import 'package:savvy_cart/screens/add_shop_list_item.dart';
import 'package:savvy_cart/screens/home_page.dart';
import 'package:savvy_cart/screens/shop_list_manager.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
      routes: <RouteBase>[
        GoRoute(
            path: 'manage/:id',
            builder: (context, state) => ShopListManager(shopListId: int.parse(state.pathParameters['id'].toString())),
          routes: [
            GoRoute(
              path: 'add-item',
              builder: (context, state) => AddShopListItem(shopListId: int.parse(state.pathParameters['id'].toString())),
            )
          ]
        )
      ]
    ),
  ],
);