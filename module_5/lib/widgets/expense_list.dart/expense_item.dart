import 'package:flutter/material.dart';
import 'package:module_5/models/expense_model.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final ExpenseModel expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            expense.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Row(children: [
            Text(
              "₹${expense.amount.toStringAsFixed(2)}",
            ),
            const Spacer(),
            Row(
              children: [
                Icon(categoryIcons[expense.category]),
                const SizedBox(
                  width: 5,
                ),
                Text(expense.formattedDate),
              ],
            )
          ])
        ]),
      ),
    );
  }
}
