import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../players/player.dart';

class Payout extends StatelessWidget {
  const Payout({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payout / Transactions')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          for (var player in appState.players)
            Column(
              children: [
                IndividualPayout(player: player),
                Text(
                    'Buy In: ${player.buyIn.toStringAsFixed(2)}, Cashed Out: ${player.cashOut.toStringAsFixed(2)} '),
                Distribute(player: player),
              ],
            ),
        ],
      ),
    );
  }
}

class Distribute extends StatelessWidget {
  const Distribute({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    if (player.transactions.isEmpty) {
      return Row(
        children: [
          player.payout == 0
              ? const Text('...broke even')
              : const Text('under construction')
        ],
      );
    } else {
      return Row(
        children: [
          for (var c in player.transactions)
            Text('${c.player.name} ${c.num.toStringAsFixed(2)} '),
        ],
      );
    }
  }
}

class IndividualPayout extends StatelessWidget {
  const IndividualPayout({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var name = player.name;
    var totalPayout = player.cashOut - player.buyIn;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: ListTile(
          title: Text(name),
        )),
        SizedBox(
          width: 140,
          child: ListTile(
            title: Text(
              totalPayout.toStringAsFixed(2),
              textAlign: TextAlign.right,
            ),
            tileColor: totalPayout.isNegative
                ? Colors.red
                : totalPayout == 0
                    ? theme.colorScheme.inversePrimary
                    : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(
              Icons.attach_money_outlined,
            ),
            minLeadingWidth: 1,
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          ),
        ),
      ],
    );
  }
}
