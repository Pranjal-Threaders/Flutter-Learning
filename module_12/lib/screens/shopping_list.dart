import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:module_11/data/categories.dart';

import 'package:module_11/models/grocery_item.dart';
import 'package:module_11/screens/new_item.dart';
import 'package:module_11/widgets/shopping_list_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<GroceryItem> _groceryList = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        "shopping-app-9abbc-default-rtdb.firebaseio.com", "shopping-list.json");

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error =
              "Failed to fetch data from the backend. Please try again later";
        });
      }

      if (response.body == "null") {
        setState(() {
          _isLoading = false;
        });

        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> _loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((categoryItem) =>
                categoryItem.value.title == item.value["category"])
            .value;

        _loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryList = _loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Something went wrong! Please try again later";
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryList.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final itemIndex = _groceryList.indexOf(item);

    setState(() {
      _groceryList.remove(item);
    });

    final url = Uri.https("shopping-app-9abbc-default-rtdb.firebaseio.com",
        "shopping-list/${item.id}.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(itemIndex, item);
      });
    }

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Item removed"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _groceryList.insert(itemIndex, item);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Items yet!"),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (context, index) {
          return ShoppingListItem(
            item: _groceryList[index],
            onDismissed: () {
              _removeItem(_groceryList[index]);
            },
          );
        },
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
