
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:savvy_cart/models/gemini_action.dart';
import 'package:savvy_cart/models/gemini_response.dart';

class GeminiShopListService {
  final String _geminiApiKey;
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  GeminiShopListService(this._geminiApiKey);

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
Based on the user's message, generate a list of actions to perform on this shopping list. 

IMPORTANT: 
- Respond with ONLY a valid JSON object, no extra text or formatting.
- Respond in the SAME LANGUAGE as the user's message. If the user writes in Spanish, respond in Spanish. If in English, respond in English.

User message: "$userMessage"

$currentShopListTextDump

Respond with a JSON object containing:
- "response": A friendly response to the user (required). Use future/conditional tense like "I can...", "I would...", "I suggest..." since actions need user confirmation. RESPOND IN THE SAME LANGUAGE AS THE USER'S MESSAGE.
- "actions": An array of actions (can be empty if no actions needed)

Each action should have:
- "operation": one of "add", "remove", "update", "check", "uncheck"
- "item": the item name
- "id": (optional) if referring to an existing item from the provided list
- "quantity": (optional) numeric value representing the AMOUNT/WEIGHT of the item (e.g., 0.2 for 200g if measured in kg) - ONLY include if you want to change the quantity, omit if keeping current quantity
- "unit_price": (optional) numeric value representing the PRICE/COST in currency (e.g., 30 for \$30) - ONLY include if you want to change the price, omit if keeping current price

IMPORTANT: Do NOT confuse quantity (amount) with unit_price (cost). Quantity is how much of the item, unit_price is how much it costs.

Examples:
{
  "response": "I can add milk and bread to your shopping list.",
  "actions": [
    {"operation": "add", "item": "milk", "quantity": 1, "unit_price": 3.50},
    {"operation": "add", "item": "bread", "quantity": 1, "unit_price": 2.25}
  ]
}

{
  "response": "I can update the calabaza to 200g and set the price to 30.",
  "actions": [
    {"operation": "update", "item": "calabaza", "quantity": 0.2, "unit_price": 30}
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

