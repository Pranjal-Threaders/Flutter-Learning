import 'package:flutter/material.dart';
import 'package:module_11/models/grocery_item.dart';

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem({
    super.key,
    required this.item,
    required this.onDismissed,
  });

  final GroceryItem item;
  final void Function() onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) => onDismissed(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              color: item.category.color,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(item.name),
            ),
            const SizedBox(width: 8),
            Text(item.quantity.toString()),
          ],
        ),
      ),
    );
  }
}
