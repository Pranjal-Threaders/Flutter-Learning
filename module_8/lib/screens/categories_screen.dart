import 'package:flutter/material.dart';

import 'package:module_8/data/dummy_data.dart';
import 'package:module_8/models/category.dart';
import 'package:module_8/models/meal.dart';
import 'package:module_8/screens/meals_screen.dart';
import 'package:module_8/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onToggleFavourite,
      required this.availibleMeals});

  final void Function(Meal meal) onToggleFavourite;
  final List<Meal> availibleMeals;

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availibleMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => MealsScreen(
            title: category.title,
            meals: filteredMeals,
            onToggleFavourite: onToggleFavourite,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
