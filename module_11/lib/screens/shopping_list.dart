import 'package:flutter/material.dart';
import 'package:module_11/models/grocery_item.dart';
import 'package:module_11/screens/new_item.dart';
import 'package:module_11/widgets/shopping_list_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<GroceryItem> _groceryList = [];

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

  void _removeItem(GroceryItem item) {
    final itemIndex = _groceryList.indexOf(item);

    setState(() {
      _groceryList.remove(item);
    });

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
