import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/decimal_form_field.dart';

class ShopListItemEditForm extends ConsumerStatefulWidget {
  final ShopListItem shopListItem;

  const ShopListItemEditForm({super.key, required this.shopListItem});

  @override
  ConsumerState<ShopListItemEditForm> createState() => _ShopListItemEditFormState();
}

class _ShopListItemEditFormState extends ConsumerState<ShopListItemEditForm> {
  final _formGlobalKey = GlobalKey<FormState>();
  Timer? _debounce;

  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitPriceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shopListItem.name);
    _quantityController = TextEditingController(
      text: widget.shopListItem.quantity.toString(),
    );
    _unitPriceController = TextEditingController(
      text: widget.shopListItem.unitPrice.toString(),
    );
  }

  void _onTotalChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    _quantityController.removeListener(_onTotalChanged);
    _quantityController.dispose();
    _unitPriceController.removeListener(_onTotalChanged);
    _unitPriceController.dispose();
    super.dispose();
  }

  void _onFormChangedDebounced() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updateShopListItem();
    });
  }

  Future _updateShopListItem() async {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    final unitPriceDecimal = Decimal.tryParse(_unitPriceController.text) ?? Decimal.zero;
    final unitPriceCents = (unitPriceDecimal * Decimal.fromInt(100)).toBigInt().toInt();
    final updatedItem = widget.shopListItem.copyWith(
      name: _nameController.text,
      quantity: Decimal.tryParse(_quantityController.text) ?? Decimal.one,
      unitPrice: Money(cents: unitPriceCents)
    );

    await ref.read(shopListItemMutationProvider.notifier).updateItem(updatedItem);
  }

  String get _currentTotal {
    final quantity = Decimal.tryParse(_quantityController.text) ?? Decimal.zero;
    final unitPrice = Decimal.tryParse(_unitPriceController.text) ?? Decimal.zero;
    final money = Money(
      cents: (unitPrice * Decimal.fromInt(100)).toBigInt().toInt(),
    );
    final total = money * quantity;
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    final saveStatus = ref.watch(shopListItemMutationProvider);

    final statusMap = <String, Map<String, dynamic>>{
      'idle': {
        'icon': Icon(Icons.done, color: Theme.of(context).primaryColor),
        'message': "All changes are saved automatically.",
      },
      'saving': {
        'icon': const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        'message': "Saving...",
      },
      'error': {
        'icon': Icon(Icons.error, color: Theme.of(context).colorScheme.error),
        'message': "Failed to save",
      },
      'saved': {
        'icon': Icon(Icons.done, color: Theme.of(context).primaryColor),
        'message': "Saved!",
      },
    };

    String currentStatus;
    if (saveStatus.isLoading) {
      currentStatus = 'saving';
    } else if (saveStatus.hasError) {
      currentStatus = 'error';
    } else if (saveStatus is AsyncData<void>) {
      currentStatus = 'saved';
    } else {
      currentStatus = 'idle';
    }

    final icon = statusMap[currentStatus]!['icon'] as Widget;
    final message = statusMap[currentStatus]!['message'] as String;

    final statusMessage = Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Text(message),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _FormHeader(statusMessageWidget: statusMessage),
              SizedBox(height: 24),
              Form(
                key: _formGlobalKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                label: Text("Item's Name")
                            ),
                            validator: (text) => text == null || text.isEmpty ? "The item's name cannot be empty" : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (_) => _onFormChangedDebounced(),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                              foregroundColor: Theme.of(context).colorScheme.onError
                          ),
                          child: const Icon(Icons.delete),
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      spacing: 8,
                      children: [
                        Flexible(
                          flex: 1,
                          child: DecimalFormField(
                            decimalPlaces: 4,
                            controller: _quantityController,
                            decoration: InputDecoration(
                              label: Text("Quantity"),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final num? number = num.tryParse(value);
                              if (number == null) return 'Invalid number';
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (_) => _onFormChangedDebounced(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: DecimalFormField(
                            controller: _unitPriceController,
                            decimalPlaces: 2,
                            decoration: InputDecoration(
                              label: Text("Price"),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final num? number = num.tryParse(value);
                              if (number == null) return 'Invalid number';
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (_) => _onFormChangedDebounced(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(text: _currentTotal),
                            decoration: InputDecoration(
                              label: Text("Total"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  final Widget statusMessageWidget;

  const _FormHeader({super.key, required this.statusMessageWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Update item", style: Theme.of(context).textTheme.titleLarge),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
        statusMessageWidget
      ],
    );
  }
}

