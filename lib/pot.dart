import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class Pot extends StatelessWidget {
  const Pot({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 131,
          child: ListTile(
            title: Text('\$${appState.getTotalPot().toStringAsFixed(2)}'),
            subtitle: const Text('Total Pot'),
          ),
        ),
        SizedBox(
          width: 131,
          child: ListTile(
            title: Text('\$${appState.getRemainingPot().toStringAsFixed(2)}'),
            subtitle: const Text('Remaining Pot'),
          ),
        ),
      ],
    );
  }
}
