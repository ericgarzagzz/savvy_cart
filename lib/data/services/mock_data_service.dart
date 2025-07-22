import 'package:decimal/decimal.dart';
import 'package:faker/faker.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import '../repositories/shop_list_repository.dart';
import '../repositories/shop_list_item_repository.dart';
import '../repositories/suggestion_repository.dart';

class MockDataService {
  MockDataService._privateConstructor();
  static final MockDataService instance = MockDataService._privateConstructor();

  final ShopListRepository _shopListRepository = ShopListRepository();
  final ShopListItemRepository _shopListItemRepository =
      ShopListItemRepository();
  final SuggestionRepository _suggestionRepository = SuggestionRepository();

  Future<void> generateMockData() async {
    final faker = Faker();

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

    for (final item in groceryItems) {
      await _suggestionRepository.add(item['name'] as String);
    }

    final now = DateTime.now();
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    final totalDays = now.difference(oneYearAgo).inDays;

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

    final totalLists = faker.randomGenerator.integer(150, min: 100);

    for (int listIndex = 0; listIndex < totalLists; listIndex++) {
      final listName =
          shopListNames[faker.randomGenerator.integer(shopListNames.length)];

      final randomDayOffset = totalDays > 0
          ? faker.randomGenerator.integer(totalDays)
          : 0;
      final randomHour = faker.randomGenerator.integer(24);
      final randomMinute = faker.randomGenerator.integer(60);
      final createdAt = oneYearAgo.add(
        Duration(
          days: randomDayOffset,
          hours: randomHour,
          minutes: randomMinute,
        ),
      );

      final listNameWithDate =
          '$listName - ${createdAt.month}/${createdAt.day}';

      final shopList = ShopList(
        name: listNameWithDate,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
      final shopListId = await _shopListRepository.add(shopList);

      final itemsInList = faker.randomGenerator.integer(15, min: 3);
      final usedItems = <String>{};

      for (int itemIndex = 0; itemIndex < itemsInList; itemIndex++) {
        Map<String, dynamic> selectedItem;
        do {
          selectedItem =
              groceryItems[faker.randomGenerator.integer(groceryItems.length)];
        } while (usedItems.contains(selectedItem['name']));

        usedItems.add(selectedItem['name'] as String);

        final quantity = Decimal.fromInt(
          faker.randomGenerator.integer(5, min: 1),
        );

        final basePrice = selectedItem['price'] as int;
        final priceVariation = (basePrice * 0.2).round();
        final priceVariationRange = priceVariation * 2;
        final finalPrice = priceVariationRange > 0
            ? basePrice +
                  faker.randomGenerator.integer(
                    priceVariationRange,
                    min: -priceVariation,
                  )
            : basePrice;

        final isChecked = faker.randomGenerator.boolean();

        final item = ShopListItem(
          shopListId: shopListId,
          name: selectedItem['name'] as String,
          quantity: quantity,
          unitPrice: Money(cents: finalPrice.clamp(50, 2000)),
          checked: isChecked,
        );

        await _shopListItemRepository.add(item);
      }
    }

    await _generateSeasonalItems(faker, oneYearAgo, now);
  }

  Future<void> _generateSeasonalItems(
    Faker faker,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final holidayLists = [
      {
        'name': 'Christmas Shopping',
        'month': 12,
        'items': [
          'Turkey',
          'Cranberries',
          'Stuffing Mix',
          'Pumpkin Pie',
          'Eggnog',
        ],
      },
      {
        'name': 'Thanksgiving Prep',
        'month': 11,
        'items': [
          'Turkey',
          'Sweet Potatoes',
          'Green Beans',
          'Pie Crust',
          'Gravy',
        ],
      },
      {
        'name': 'Summer BBQ',
        'month': 7,
        'items': [
          'Hamburger Buns',
          'Hot Dogs',
          'Charcoal',
          'Corn on the Cob',
          'Watermelon',
        ],
      },
      {
        'name': 'Back to School',
        'month': 8,
        'items': [
          'Lunch Bags',
          'Granola Bars',
          'Juice Boxes',
          'Sandwich Bread',
          'Peanut Butter',
        ],
      },
    ];

    final allSeasonalItems = <String>{};
    for (final holiday in holidayLists) {
      final items = holiday['items'] as List<String>;
      allSeasonalItems.addAll(items);
    }

    for (final itemName in allSeasonalItems) {
      await _suggestionRepository.add(itemName);
    }

    for (final holiday in holidayLists) {
      final month = holiday['month'] as int;

      final dates = <DateTime>[];

      if (startDate.year == endDate.year) {
        if (month >= startDate.month && month <= endDate.month) {
          dates.add(DateTime(startDate.year, month));
        }
      } else {
        if (month >= startDate.month) {
          dates.add(DateTime(startDate.year, month));
        }
        if (month <= endDate.month) {
          dates.add(DateTime(endDate.year, month));
        }
      }

      for (final holidayDate in dates) {
        final dayOfMonth = faker.randomGenerator.integer(28, min: 1);
        final randomHour = faker.randomGenerator.integer(24);
        final randomMinute = faker.randomGenerator.integer(60);
        final createdAt = DateTime(
          holidayDate.year,
          holidayDate.month,
          dayOfMonth,
          randomHour,
          randomMinute,
        );

        if (createdAt.isAfter(startDate) && createdAt.isBefore(endDate)) {
          final shopList = ShopList(
            name: holiday['name'] as String,
            createdAt: createdAt,
            updatedAt: createdAt,
          );
          final shopListId = await _shopListRepository.add(shopList);

          final items = holiday['items'] as List<String>;
          for (final itemName in items) {
            final quantity = Decimal.fromInt(
              faker.randomGenerator.integer(3, min: 1),
            );
            final price = faker.randomGenerator.integer(800, min: 200);
            final isChecked = faker.randomGenerator.boolean();

            final item = ShopListItem(
              shopListId: shopListId,
              name: itemName,
              quantity: quantity,
              unitPrice: Money(cents: price),
              checked: isChecked,
            );

            await _shopListItemRepository.add(item);
          }
        }
      }
    }
  }
}
