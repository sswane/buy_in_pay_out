import 'package:flutter/material.dart';
import 'payout.dart';

class DeterminePayout extends StatelessWidget {
  const DeterminePayout({super.key, required this.remainingPot});
  final double remainingPot;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: remainingPot == 0
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Payout()),
                  );
                }
              : null,
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
