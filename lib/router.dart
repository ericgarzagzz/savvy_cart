import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/screens/screens.dart';
import 'package:savvy_cart/utils/utils.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

Widget _buildErrorPage(BuildContext context, String message) {
  return Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context)!.error)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
            child: Text(AppLocalizations.of(context)!.goHome),
          ),
        ],
      ),
    ),
  );
}

final router = GoRouter(
  errorBuilder: (context, state) =>
      _buildErrorPage(context, 'Page not found: ${state.uri}'),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'manage/:id',
          builder: (context, state) {
            final shopListId = ParsingUtils.parseIntSafely(
              state.pathParameters['id'],
            );
            if (shopListId == null) {
              return _buildErrorPage(context, 'Invalid shop list ID');
            }
            return ShopListManager(shopListId: shopListId);
          },
          routes: [
            GoRoute(
              path: 'add-item',
              builder: (context, state) {
                final shopListId = ParsingUtils.parseIntSafely(
                  state.pathParameters['id'],
                );
                if (shopListId == null) {
                  return _buildErrorPage(context, 'Invalid shop list ID');
                }
                return AddShopListItem(shopListId: shopListId);
              },
            ),
            GoRoute(
              path: 'chat',
              builder: (context, state) {
                final shopListId = ParsingUtils.parseIntSafely(
                  state.pathParameters['id'],
                );
                if (shopListId == null) {
                  return _buildErrorPage(context, 'Invalid shop list ID');
                }
                return ShopListChat(shopListId: shopListId);
              },
            ),
            GoRoute(
              path: 'price-chart/:itemName',
              builder: (context, state) {
                final itemName = state.pathParameters['itemName'];
                if (itemName == null) {
                  return _buildErrorPage(context, 'Invalid item name');
                }
                return PriceChartScreen(
                  itemName: Uri.decodeComponent(itemName),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'insights',
          builder: (context, state) => const InsightsPage(),
          routes: [
            GoRoute(
              path: 'price-search',
              builder: (context, state) => const PriceSearchScreen(),
              routes: [
                GoRoute(
                  path: 'price-chart/:itemName',
                  builder: (context, state) {
                    final itemName = state.pathParameters['itemName'];
                    if (itemName == null) {
                      return _buildErrorPage(context, 'Invalid item name');
                    }
                    return PriceChartScreen(
                      itemName: Uri.decodeComponent(itemName),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'price-chart/:itemName',
              builder: (context, state) {
                final itemName = state.pathParameters['itemName'];
                if (itemName == null) {
                  return _buildErrorPage(context, 'Invalid item name');
                }
                return PriceChartScreen(
                  itemName: Uri.decodeComponent(itemName),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'search-lists',
          builder: (context, state) => const ShopListSearchScreen(),
          routes: [
            GoRoute(
              path: 'manage/:id',
              builder: (context, state) {
                final shopListId = ParsingUtils.parseIntSafely(
                  state.pathParameters['id'],
                );
                if (shopListId == null) {
                  return _buildErrorPage(context, 'Invalid shop list ID');
                }
                return ShopListManager(shopListId: shopListId);
              },
              routes: [
                GoRoute(
                  path: 'add-item',
                  builder: (context, state) {
                    final shopListId = ParsingUtils.parseIntSafely(
                      state.pathParameters['id'],
                    );
                    if (shopListId == null) {
                      return _buildErrorPage(context, 'Invalid shop list ID');
                    }
                    return AddShopListItem(shopListId: shopListId);
                  },
                ),
                GoRoute(
                  path: 'chat',
                  builder: (context, state) {
                    final shopListId = ParsingUtils.parseIntSafely(
                      state.pathParameters['id'],
                    );
                    if (shopListId == null) {
                      return _buildErrorPage(context, 'Invalid shop list ID');
                    }
                    return ShopListChat(shopListId: shopListId);
                  },
                ),
                GoRoute(
                  path: 'price-chart/:itemName',
                  builder: (context, state) {
                    final itemName = state.pathParameters['itemName'];
                    if (itemName == null) {
                      return _buildErrorPage(context, 'Invalid item name');
                    }
                    return PriceChartScreen(
                      itemName: Uri.decodeComponent(itemName),
                    );
                  },
                ),
              ],
            ),
          ],
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
