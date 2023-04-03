import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Payout extends StatelessWidget {
  const Payout({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payout under construction...')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          for (var player in appState.players)
            Column(
              children: [
                IndividualPayout(player: player),
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
    var word = player.payout == 0
        ? 'broke even, does not owe or is owed'
        : 'under construction';

    return Row(
      children: [
        Text(word),
      ],
    );
  }
}

class IndividualPayout extends StatelessWidget {
  const IndividualPayout({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var name = player.name;
    var payout = player.payout;

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
              payout.toStringAsFixed(2),
              textAlign: TextAlign.right,
            ),
            tileColor: payout.isNegative
                ? Colors.red
                : payout == 0
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
