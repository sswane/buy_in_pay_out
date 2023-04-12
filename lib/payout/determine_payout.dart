import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'payout.dart';

class DeterminePayout extends StatelessWidget {
  const DeterminePayout({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: appState.getRemainingPot() == 0
              ? () {
                  appState.payout();
                  appState.calculateTransactions(appState.players);
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => const Payout(),
                      ))
                      .then((value) => appState
                          .clearAllTransactions()); // clear transactions if back button used
                }
              : null, // disable button if money is left in pot
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('Determine Payout'),
        ),
      ],
    );
  }
}
