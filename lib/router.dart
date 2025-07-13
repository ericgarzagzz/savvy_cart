import 'package:go_router/go_router.dart';
import 'package:savvy_cart/screens/add_shop_list_item.dart';
import 'package:savvy_cart/screens/backup_management_screen.dart';
import 'package:savvy_cart/screens/home_page.dart';
import 'package:savvy_cart/screens/shop_list_chat.dart';
import 'package:savvy_cart/screens/settings.dart';
import 'package:savvy_cart/screens/shop_list_manager.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'manage/:id',
          builder: (context, state) => ShopListManager(
            shopListId: int.parse(state.pathParameters['id']!),
          ),
          routes: [
            GoRoute(
              path: 'add-item',
              builder: (context, state) => AddShopListItem(
                shopListId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: 'chat',
              builder: (context, state) => ShopListChat(
                shopListId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const Settings(),
          routes: [
            GoRoute(
              path: 'data-management',
              builder: (context, state) => const BackupManagementScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
