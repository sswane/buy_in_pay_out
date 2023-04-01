import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Pot extends StatelessWidget {
  const Pot({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // Refactor this later...would be great to dynamically have these values from state
    double totalPot = appState.players.fold(0, (total, p) => total + p.buyIn);
    double remainingPot =
        totalPot - appState.players.fold(0, (total, p) => total + p.cashOut);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 110,
          child: ListTile(
            title: Text('\$${totalPot.toStringAsFixed(2)}'),
            subtitle: const Text('Total Pot'),
          ),
        ),
        SizedBox(
          width: 130,
          child: ListTile(
            title: Text('\$${remainingPot.toStringAsFixed(2)}'),
            subtitle: const Text('Remaining Pot'),
          ),
        ),
      ],
    );
  }
}
