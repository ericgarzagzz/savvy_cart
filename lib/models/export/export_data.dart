import 'package:savvy_cart/domain/models/chat_message.dart';
import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/domain/models/suggestion.dart';
import 'package:savvy_cart/models/settings/ai_settings.dart';

class ExportData {
  final String formatVersion;
  final int databaseVersion;
  final String appVersion;
  final DateTime exportDate;
  final bool includeSettings;
  
  // Raw table data for migration purposes
  final Map<String, List<Map<String, dynamic>>> rawTables;
  
  // Parsed models for current version compatibility
  final List<ShopList> shopLists;
  final List<ShopListItem> shopListItems;
  final List<Suggestion> suggestions;
  final List<ChatMessage> chatMessages;
  final AiSettings? settings;

  const ExportData({
    required this.formatVersion,
    required this.databaseVersion,
    required this.appVersion,
    required this.exportDate,
    required this.includeSettings,
    required this.rawTables,
    required this.shopLists,
    required this.shopListItems,
    required this.suggestions,
    required this.chatMessages,
    this.settings,
  });

  factory ExportData.fromJson(Map<String, dynamic> json) {
    return ExportData(
      formatVersion: json['formatVersion'] as String,
      databaseVersion: json['databaseVersion'] as int,
      appVersion: json['appVersion'] as String,
      exportDate: DateTime.parse(json['exportDate'] as String),
      includeSettings: json['includeSettings'] as bool,
      rawTables: Map<String, List<Map<String, dynamic>>>.from(
        json['rawTables'].map(
          (key, value) => MapEntry(
            key as String,
            List<Map<String, dynamic>>.from(
              value.map((item) => Map<String, dynamic>.from(item)),
            ),
          ),
        ),
      ),
      shopLists: (json['shopLists'] as List<dynamic>)
          .map((item) => ShopList.fromMap(item as Map<String, dynamic>))
          .toList(),
      shopListItems: (json['shopListItems'] as List<dynamic>)
          .map((item) => ShopListItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((item) => Suggestion.fromMap(item as Map<String, dynamic>))
          .toList(),
      chatMessages: (json['chatMessages'] as List<dynamic>)
          .map((item) => ChatMessage.fromMap(item as Map<String, dynamic>))
          .toList(),
      settings: json['settings'] != null
          ? AiSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formatVersion': formatVersion,
      'databaseVersion': databaseVersion,
      'appVersion': appVersion,
      'exportDate': exportDate.toIso8601String(),
      'includeSettings': includeSettings,
      'rawTables': rawTables,
      'shopLists': shopLists.map((item) => item.toMap()).toList(),
      'shopListItems': shopListItems.map((item) => item.toMap()).toList(),
      'suggestions': suggestions.map((item) => item.toMap()).toList(),
      'chatMessages': chatMessages.map((item) => item.toMap()).toList(),
      'settings': settings?.toJson(),
    };
  }
}