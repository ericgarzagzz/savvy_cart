import 'package:go_router/go_router.dart';
import 'package:savvy_cart/screens/screens.dart';

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
          path: 'insights',
          builder: (context, state) => const InsightsPage(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const Settings(),
          routes: [
            GoRoute(
              path: 'ai',
              builder: (context, state) => const AiSettingsScreen(),
            ),
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
