import 'repositories/shop_list_repository.dart';
import 'repositories/shop_list_item_repository.dart';
import 'repositories/chat_message_repository.dart';
import 'repositories/suggestion_repository.dart';
import 'repositories/analytics_repository.dart';
import 'services/mock_data_service.dart';
import 'database/database_manager.dart';

class DataManager {
  DataManager._privateConstructor();
  static final DataManager instance = DataManager._privateConstructor();

  final ShopListRepository shopLists = ShopListRepository();
  final ShopListItemRepository shopListItems = ShopListItemRepository();
  final ChatMessageRepository chatMessages = ChatMessageRepository();
  final SuggestionRepository suggestions = SuggestionRepository();
  final AnalyticsRepository analytics = AnalyticsRepository();
  final MockDataService mockData = MockDataService.instance;

  Future<void> purgeDatabase() async {
    return DatabaseManager.instance.purgeDatabase();
  }
}
