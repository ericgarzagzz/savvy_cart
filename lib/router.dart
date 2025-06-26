import 'package:go_router/go_router.dart';
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
            builder: (context, state) => ShopListManager(shopListId: int.parse(state.pathParameters['id'].toString()))
        )
      ]
    ),
  ],
);