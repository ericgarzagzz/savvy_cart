import 'package:flutter/material.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list.dart';

class CreateShopList extends StatefulWidget {
  const CreateShopList({super.key});

  @override
  State<CreateShopList> createState() => _CreateShopListState();
}

class _CreateShopListState extends State<CreateShopList> {
  final _formKey = GlobalKey<FormState>();
  final _nameInputController = TextEditingController();

  Future<void> _saveShopList(String name) async {
    await DatabaseHelper.instance.addShopList(ShopList(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add a new list",
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Flexible(
                flex: 1,
                child: TextFormField(
                  controller: _nameInputController,
                  decoration: InputDecoration(
                      labelText: "List's name",
                  ),
                  validator: (text) => text == null || text.isEmpty ? "The list's name cannot be empty" : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DatabaseHelper.instance.addShopList(ShopList(name: _nameInputController.text));
                    setState(() {
                      _formKey.currentState!.reset();
                    });
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 4),
                    Text("Save"),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}