import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:faker/faker.dart';
import 'package:decimal/decimal.dart';

import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final themeService = ref.watch(themeServiceProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final versionAsync = ref.watch(packageInfoProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("SavvyCart settings"),
      ),
      body: SettingsList(
        platform: DevicePlatform.android,
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: Theme.of(context).cardColor,
          titleTextColor: Theme.of(context).textTheme.headlineSmall?.color,
          settingsTileTextColor: Theme.of(context).textTheme.bodyLarge?.color,
          tileDescriptionTextColor: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: Theme.of(context).cardColor,
          titleTextColor: Theme.of(context).textTheme.headlineSmall?.color,
          settingsTileTextColor: Theme.of(context).textTheme.bodyLarge?.color,
          tileDescriptionTextColor: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        sections: [
          SettingsSection(
            title: Text('Appearance'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.palette),
                title: Text('Theme'),
                value: Text('Current: ${themeService.getThemeModeDisplayName(currentThemeMode)}'),
                onPressed: (context) => _showThemeDialog(context, ref),
              ),
            ],
          ),
          SettingsSection(
            title: Text('AI Assistant'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.auto_awesome),
                title: Text('AI Settings'),
                value: Text(
                  aiSettingsState.hasValidApiKey
                    ? 'Ready'
                    : aiSettingsState.settings.apiKey.isNotEmpty
                        ? 'Not verified'
                        : 'Not configured'
                ),
                onPressed: (context) => context.push('/settings/ai'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Data'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.backup),
                title: Text('Backup & Restore'),
                value: Text('Manage backups'),
                onPressed: (context) => context.push('/settings/data-management'),
              ),
            ],
          ),
          if (kDebugMode) SettingsSection(
            title: Text('Developer'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.data_usage),
                title: Text('Generate Mock Data'),
                value: Text('Add sample shopping lists'),
                onPressed: (context) => _showGenerateMockDataDialog(context),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.delete_forever),
                title: Text('Delete Database'),
                value: Text('Clear all data'),
                onPressed: (context) => _showDeleteDatabaseDialog(context),
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: [
              versionAsync.when(
                data: (packageInfo) => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  value: Text('${packageInfo.version} (${packageInfo.buildNumber})'),
                ),
                loading: () => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  value: Text('Loading...'),
                ),
                error: (_, __) => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  value: Text('1.0.0+1'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generateMockData() async {
    final faker = Faker();
    final db = DatabaseHelper.instance;
    
    // Common grocery items with realistic prices (in cents)
    final groceryItems = [
      {'name': 'Milk', 'price': 349},
      {'name': 'Bread', 'price': 289},
      {'name': 'Eggs', 'price': 425},
      {'name': 'Bananas', 'price': 159},
      {'name': 'Apples', 'price': 299},
      {'name': 'Chicken Breast', 'price': 899},
      {'name': 'Ground Beef', 'price': 649},
      {'name': 'Cheese', 'price': 549},
      {'name': 'Yogurt', 'price': 199},
      {'name': 'Cereal', 'price': 459},
      {'name': 'Rice', 'price': 199},
      {'name': 'Pasta', 'price': 149},
      {'name': 'Tomatoes', 'price': 249},
      {'name': 'Onions', 'price': 99},
      {'name': 'Potatoes', 'price': 179},
      {'name': 'Carrots', 'price': 129},
      {'name': 'Spinach', 'price': 299},
      {'name': 'Orange Juice', 'price': 399},
      {'name': 'Butter', 'price': 449},
      {'name': 'Olive Oil', 'price': 699},
      {'name': 'Salt', 'price': 99},
      {'name': 'Sugar', 'price': 199},
      {'name': 'Flour', 'price': 299},
      {'name': 'Salmon', 'price': 1299},
      {'name': 'Avocado', 'price': 199},
      {'name': 'Bell Peppers', 'price': 349},
      {'name': 'Broccoli', 'price': 229},
      {'name': 'Strawberries', 'price': 449},
      {'name': 'Blueberries', 'price': 599},
      {'name': 'Peanut Butter', 'price': 399},
    ];

    // Generate shopping lists across the year
    final currentYear = DateTime.now().year;
    final shopListNames = [
      'Weekly Groceries',
      'Weekend Shopping',
      'Monthly Stock-up',
      'Party Supplies',
      'Holiday Shopping',
      'Quick Run',
      'Bulk Shopping',
      'Healthy Meals',
      'Snack Run',
      'Dinner Ingredients',
    ];

    for (int month = 1; month <= 12; month++) {
      // Generate 3-8 shopping lists per month
      final listsInMonth = faker.randomGenerator.integer(6, min: 3);
      
      for (int listIndex = 0; listIndex < listsInMonth; listIndex++) {
        // Create shopping list
        final listName = shopListNames[faker.randomGenerator.integer(shopListNames.length)];
        final dayOfMonth = faker.randomGenerator.integer(28, min: 1);
        final listNameWithDate = '$listName - $month/$dayOfMonth';
        
        final shopList = ShopList(name: listNameWithDate);
        final shopListId = await db.addShopList(shopList);
        
        // Generate 3-15 items per shopping list
        final itemsInList = faker.randomGenerator.integer(13, min: 3);
        final usedItems = <String>{};
        
        for (int itemIndex = 0; itemIndex < itemsInList; itemIndex++) {
          // Pick a random grocery item that hasn't been used in this list
          Map<String, dynamic> selectedItem;
          do {
            selectedItem = groceryItems[faker.randomGenerator.integer(groceryItems.length)];
          } while (usedItems.contains(selectedItem['name']));
          
          usedItems.add(selectedItem['name'] as String);
          
          // Generate realistic quantity (1-5 for most items)
          final quantity = Decimal.fromInt(faker.randomGenerator.integer(5, min: 1));
          
          // Add some price variation (±20%)
          final basePrice = selectedItem['price'] as int;
          final priceVariation = (basePrice * 0.2).round();
          final finalPrice = basePrice + faker.randomGenerator.integer(priceVariation * 2, min: -priceVariation);
          
          // 70% chance the item is checked (purchased)
          final isChecked = faker.randomGenerator.boolean();
          
          final item = ShopListItem(
            shopListId: shopListId,
            name: selectedItem['name'] as String,
            quantity: quantity,
            unitPrice: Money(cents: finalPrice),
            checked: isChecked,
          );
          
          await db.addShopListItem(item);
        }
      }
    }
    
    // Generate some additional seasonal items
    await _generateSeasonalItems(db, faker, currentYear);
  }

  Future<void> _generateSeasonalItems(DatabaseHelper db, Faker faker, int year) async {
    // Holiday shopping lists
    final holidayLists = [
      {'name': 'Christmas Shopping', 'month': 12, 'items': ['Turkey', 'Cranberries', 'Stuffing Mix', 'Pumpkin Pie', 'Eggnog']},
      {'name': 'Thanksgiving Prep', 'month': 11, 'items': ['Turkey', 'Sweet Potatoes', 'Green Beans', 'Pie Crust', 'Gravy']},
      {'name': 'Summer BBQ', 'month': 7, 'items': ['Hamburger Buns', 'Hot Dogs', 'Charcoal', 'Corn on the Cob', 'Watermelon']},
      {'name': 'Back to School', 'month': 8, 'items': ['Lunch Bags', 'Granola Bars', 'Juice Boxes', 'Sandwich Bread', 'Peanut Butter']},
    ];

    for (final holiday in holidayLists) {
      final shopList = ShopList(name: holiday['name'] as String);
      final shopListId = await db.addShopList(shopList);
      
      final items = holiday['items'] as List<String>;
      for (final itemName in items) {
        final quantity = Decimal.fromInt(faker.randomGenerator.integer(3, min: 1));
        final price = faker.randomGenerator.integer(800, min: 200);
        final isChecked = faker.randomGenerator.boolean();
        
        final item = ShopListItem(
          shopListId: shopListId,
          name: itemName,
          quantity: quantity,
          unitPrice: Money(cents: price),
          checked: isChecked,
        );
        
        await db.addShopListItem(item);
      }
    }
  }

  void _showGenerateMockDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generate Mock Data'),
        content: Text('This will create sample shopping lists with items across the year for analytics testing. This may take a few moments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Generating mock data...')),
                );
                await _generateMockData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mock data generated successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error generating mock data: $e')),
                );
              }
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDatabaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Database'),
        content: Text('This will permanently delete all your data including shopping lists, items, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await DatabaseHelper.instance.purgeDatabase();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Database deleted successfully')),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting database: $e')),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final themeService = ref.read(themeServiceProvider);
    final currentThemeMode = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(themeService.getThemeModeDisplayName(mode)),
              subtitle: Text(_getThemeModeDescription(mode)),
              value: mode,
              groupValue: currentThemeMode,
              onChanged: (AppThemeMode? value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getThemeModeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system setting';
    }
  }
}
