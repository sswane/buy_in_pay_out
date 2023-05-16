import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../players/player.dart';
import '../players/player_info.dart';

class Payout extends StatelessWidget {
  const Payout({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Payout')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.reset();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('New Game'),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          for (var player in appState.players)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IndividualPayout(player: player),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Distribute(transactions: player.transactions),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
        ],
      ),
    );
  }
}

class Distribute extends StatelessWidget {
  const Distribute({super.key, required this.transactions});
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 20.0),
      child: Wrap(
        spacing: 20.0,
        children: <Widget>[
          for (var t in transactions)
            Wrap(
              children: [
                Icon(
                  Icons.person_outline,
                  semanticLabel: 'Player',
                  color: theme.colorScheme.primary,
                ),
                const Padding(padding: EdgeInsets.only(right: 5.0)),
                t.num > 0
                    ? Text('${t.player.name} \$${t.num.toStringAsFixed(2)}')
                    : Text(
                        '${t.player.name} -\$${t.num.abs().toStringAsFixed(2)}')
              ],
            ),
          if (transactions.isEmpty)
            Wrap(
              children: [
                Icon(
                  Icons.balance_outlined,
                  semanticLabel: 'Broke Even',
                  color: theme.colorScheme.primary,
                ),
                const Padding(padding: EdgeInsets.only(right: 5.0)),
                const Text('broke even')
              ],
            )
        ],
      ),
    );
  }
}

class IndividualPayout extends StatelessWidget {
  const IndividualPayout({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var totalPayout = player.cashOut - player.buyIn;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: PlayerInfo(player: player),
        ),
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
