import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListItemEditForm extends ConsumerStatefulWidget {
  final ShopListItem shopListItem;

  const ShopListItemEditForm({super.key, required this.shopListItem});

  @override
  ConsumerState<ShopListItemEditForm> createState() =>
      _ShopListItemEditFormState();
}

class _ShopListItemEditFormState extends ConsumerState<ShopListItemEditForm> {
  final _formGlobalKey = GlobalKey<FormState>();
  Timer? _debounce;

  late final TextEditingController _quantityController;
  late final TextEditingController _unitPriceController;

  final _quantityFocusNode = FocusNode();
  final _unitPriceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.shopListItem.quantity.toString(),
    );
    _unitPriceController = TextEditingController(
      text: widget.shopListItem.unitPrice.toString(),
    );

    _quantityFocusNode.addListener(() {
      if (_quantityFocusNode.hasFocus) {
        _quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _quantityController.value.text.length,
        );
      }
    });

    _unitPriceFocusNode.addListener(() {
      if (_unitPriceFocusNode.hasFocus) {
        _unitPriceController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _unitPriceController.value.text.length,
        );
      }
    });
  }

  void _onTotalChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
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

    final unitPriceDecimal =
        Decimal.tryParse(_unitPriceController.text) ?? Decimal.zero;
    final unitPriceCents = (unitPriceDecimal * Decimal.fromInt(100))
        .toBigInt()
        .toInt();
    final updatedItem = widget.shopListItem.copyWith(
      quantity: Decimal.tryParse(_quantityController.text) ?? Decimal.one,
      unitPrice: Money(cents: unitPriceCents),
    );

    await ref
        .read(shopListItemMutationProvider.notifier)
        .updateItem(updatedItem);
  }

  String get _currentTotal {
    final quantity = Decimal.tryParse(_quantityController.text) ?? Decimal.zero;
    final unitPrice =
        Decimal.tryParse(_unitPriceController.text) ?? Decimal.zero;
    final money = Money(
      cents: (unitPrice * Decimal.fromInt(100)).toBigInt().toInt(),
    );
    final total = money * quantity;
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentItemAsync = ref.watch(
      getShopListItemByIdProvider(widget.shopListItem.id ?? 0),
    );

    return currentItemAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('Error loading item')),
      ),
      data: (currentItem) {
        if (currentItem == null) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Item not found')),
          );
        }
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      currentItem.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => ShopListItemNameEditDialog(
                            shopListItem: currentItem,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Item'),
                            content: Text(
                              'Are you sure you want to delete "${currentItem.name}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm != true) return;

                        await ref
                            .read(shopListItemMutationProvider.notifier)
                            .deleteItem(currentItem.id ?? 0);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.delete),
                      iconSize: 20,
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formGlobalKey,
                  child: Row(
                    spacing: 8,
                    children: [
                      Flexible(
                        flex: 1,
                        child: DecimalFormField(
                          decimalPlaces: 4,
                          controller: _quantityController,
                          focusNode: _quantityFocusNode,
                          decoration: InputDecoration(label: Text("Quantity")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
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
                          focusNode: _unitPriceFocusNode,
                          decimalPlaces: 2,
                          decoration: InputDecoration(label: Text("Price")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
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
                          controller: TextEditingController(
                            text: _currentTotal,
                          ),
                          decoration: InputDecoration(label: Text("Total")),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
