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
      appBar: AppBar(title: const Text('Payout')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          for (var player in appState.players)
            Column(
              children: [
                IndividualPayout(player: player),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var t in transactions)
          t.num > 0
              ? Text('${t.player.name} \$${t.num.toStringAsFixed(2)}  ')
              : Text(
                  '${t.player.name} -\$${t.num.abs().toStringAsFixed(2)}  ',
                ),
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
    var totalPayout = player.cashOut - player.buyIn;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(name),
              subtitle: Distribute(transactions: player.transactions),
              controlAffinity: ListTileControlAffinity.leading,
              leading: Icon(
                Icons.info_outline,
                color: theme.primaryColor,
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'Buy In: \$${player.buyIn.toStringAsFixed(2)}  Cash Out: \$${player.cashOut.toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
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
