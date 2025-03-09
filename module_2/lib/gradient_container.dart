import 'package:flutter/material.dart';
import 'package:module_2/dice_roller.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 93, 53, 161),
          Color.fromARGB(255, 192, 48, 217)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: const Center(child: DiceRoller()),
    );
  }
}
