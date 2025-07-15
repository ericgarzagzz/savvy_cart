
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/models/models.dart';

class GeminiShopListService {
  final String _geminiApiKey;
  final String _model;
  static const String _baseUrlTemplate = 'https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent';

  GeminiShopListService(this._geminiApiKey, {String? model}) 
    : _model = model ?? 'gemini-2.0-flash';
    
  String get _baseUrl => _baseUrlTemplate.replaceAll('{model}', _model);

  Future<GeminiResponse> processTextInstructions(
      String userMessage, List<ShopListItem> currentShopList) async {
    if (kDebugMode) {
      print('=== PROCESSING TEXT INSTRUCTIONS ===');
      print('User message: $userMessage');
    }

    final String currentShopListTextDump = currentShopList.isEmpty
        ? "No items in the current shopping list."
        : "Current Shopping List:\n${currentShopList.map((item) {
              return "- Item: ${item.name}, Quantity: ${item.quantity}, Unit Price: ${item.unitPrice.toStringWithLocale()}, Checked: ${item.checked ? 'Yes' : 'No'}, ID: ${item.id ?? 'N/A'}";
            }).join('\n')}";

    final prompt = """
You are a shopping list assistant. Analyze the user's message and determine if they want to:
1. Perform actions on the shopping list (add, remove, update, check items)
2. Get information about the shopping list (calculate totals, ask questions)
3. Both (answer questions AND perform actions)

IMPORTANT: 
- Respond with ONLY a valid JSON object, no extra text or formatting.
- Respond in the SAME LANGUAGE as the user's message. If the user writes in Spanish, respond in Spanish. If in English, respond in English.

User message: "$userMessage"

$currentShopListTextDump

Respond with a JSON object containing:
- "response": A helpful response to the user (required). For informational queries, give direct answers (e.g., "The total is \$25.50"). For action requests, use future/conditional tense (e.g., "I can add milk to your list"). RESPOND IN THE SAME LANGUAGE AS THE USER'S MESSAGE.
- "actions": An array of actions (empty if user is only asking for information)

For informational queries (calculations, questions about the list):
- Provide direct, complete answers in the "response" field
- Leave "actions" array empty
- Examples: "What's my total?", "How many items do I have?", "Which items are checked?"

For action requests:
- Use conditional language in "response" since actions need confirmation
- Include appropriate actions in the "actions" array

Each action should have:
- "operation": one of "add", "remove", "update", "check", "uncheck"
- "item": the item name
- "id": (optional) if referring to an existing item from the provided list
- "quantity": (optional) numeric value representing the AMOUNT/WEIGHT of the item (e.g., 0.2 for 200g if measured in kg) - ONLY include if you want to change the quantity, omit if keeping current quantity
- "unit_price": (optional) numeric value representing the PRICE/COST in currency (e.g., 30 for \$30) - ONLY include if you want to change the price, omit if keeping current price

IMPORTANT: Do NOT confuse quantity (amount) with unit_price (cost). Quantity is how much of the item, unit_price is how much it costs.

Examples:

Information query:
{
  "response": "Your total is \$15.75 for 3 items. You have checked 1 item worth \$3.50.",
  "actions": []
}

Action request:
{
  "response": "I can add milk and bread to your shopping list.",
  "actions": [
    {"operation": "add", "item": "milk", "quantity": 1, "unit_price": 3.50},
    {"operation": "add", "item": "bread", "quantity": 1, "unit_price": 2.25}
  ]
}

Both information and action:
{
  "response": "Your current total is \$12.25. I can also add apples to your list.",
  "actions": [
    {"operation": "add", "item": "apples", "quantity": 1, "unit_price": 4.00}
  ]
}

Remember: Return ONLY valid JSON, no additional text or code blocks.""";

    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 1000,
        }
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = responseData['candidates']?[0]?['content']?['parts']?[0]?['text'];
        
        if (content != null) {
          if (kDebugMode) {
            print('Gemini response: $content');
          }
          
          try {
            // Clean the content to extract JSON
            String cleanContent = content.trim();
            
            // Remove markdown code blocks if present
            if (cleanContent.startsWith('```json')) {
              cleanContent = cleanContent.substring(7);
            }
            if (cleanContent.startsWith('```')) {
              cleanContent = cleanContent.substring(3);
            }
            if (cleanContent.endsWith('```')) {
              cleanContent = cleanContent.substring(0, cleanContent.length - 3);
            }
            cleanContent = cleanContent.trim();
            
            // Try to parse as JSON
            final jsonResponse = jsonDecode(cleanContent);
            final responseText = jsonResponse['response'] ?? "I've processed your request.";
            final actionsJson = jsonResponse['actions'] as List<dynamic>? ?? [];
            
            final actions = actionsJson
                .map((actionJson) => GeminiAction.fromJson(actionJson as Map<String, dynamic>))
                .toList();

            return GeminiResponse(
              prompt: responseText,
              actions: actions,
            );
          } catch (jsonError) {
            if (kDebugMode) {
              print('JSON parsing failed: $jsonError');
              print('Raw content: $content');
            }
            
            // If JSON parsing fails, extract a meaningful response
            String fallbackResponse = content;
            
            // Try to extract just the text if it's partially formatted
            if (content.contains('"response"')) {
              // Look for response field in the text
              final responseMatch = RegExp(r'"response"\s*:\s*"([^"]+)"').firstMatch(content);
              if (responseMatch != null) {
                fallbackResponse = responseMatch.group(1) ?? content;
              }
            }
            
            return GeminiResponse(
              prompt: fallbackResponse.length > 200 
                  ? "I've analyzed your request and have some suggestions." 
                  : fallbackResponse,
              actions: [],
            );
          }
        }
      }

      throw Exception('Failed to get response from Gemini API: ${response.statusCode}');
    } catch (e) {
      if (kDebugMode) {
        print('Error calling Gemini API: $e');
      }
      throw Exception('Failed to process message with Gemini: $e');
    }
  }

  Future<void> executeGeminiActions(
      GeminiResponse geminiResponse, int shopListId) async {
    for (final action in geminiResponse.actions) {
      switch (action.operation) {
        case GeminiOperation.add:
          await DatabaseHelper.instance.addShopListItem(
            ShopListItem(
              shopListId: shopListId,
              name: action.item,
              quantity: Decimal.parse((action.quantity ?? 1).toString()),
              unitPrice: Money(cents: ((action.unitPrice ?? 0) * 100).toInt()),
            ),
          );
          break;
        case GeminiOperation.remove:
          if (action.id != null) {
            await DatabaseHelper.instance.removeShopListItem(action.id!);
          } else {
            await DatabaseHelper.instance.removeShopListItemByName(shopListId, action.item);
          }
          break;
        case GeminiOperation.update:
          await DatabaseHelper.instance.updateShopListItemByName(
            shopListId,
            action.item,
            quantity: action.quantity != null ? Decimal.parse(action.quantity!.toString()) : null,
            unitPrice: action.unitPrice != null ? Money(cents: (action.unitPrice! * 100).toInt()) : null,
          );
          break;
        case GeminiOperation.check:
          if (action.id != null) {
            await DatabaseHelper.instance.setShopListItemChecked(action.id!, true);
          } else {
            await DatabaseHelper.instance.setShopListItemCheckedByName(shopListId, action.item, true);
          }
          break;
        case GeminiOperation.uncheck:
          if (action.id != null) {
            await DatabaseHelper.instance.setShopListItemChecked(action.id!, false);
          } else {
            await DatabaseHelper.instance.setShopListItemCheckedByName(shopListId, action.item, false);
          }
          break;
      }
    }
  }
}

