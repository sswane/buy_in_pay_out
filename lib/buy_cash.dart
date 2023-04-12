import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'buy_in/increase.dart';
import 'cash_out/cash_all.dart';
import 'cash_out/cash_one.dart';
import 'payout/determine_payout.dart';
import 'players/add_midgame.dart';
import 'pot.dart';
import 'players/player.dart';

class BuyCash extends StatefulWidget {
  const BuyCash({super.key});
  @override
  State<BuyCash> createState() => _BuyCashState();
}

class _BuyCashState extends State<BuyCash> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Buy In Cash Out')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.person_add),
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AddPlayerMidGame();
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: appState.getRemainingPot() == 0
                    ? null
                    : () {
                        appState.removePlayersWithNoBuyIn();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CashAllOut()),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('Cash All Out'),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                for (var player in appState.players)
                  IndividualBuyCash(
                    player: player,
                  ),
              ],
            ),
          ),
          const Pot(),
          const DeterminePayout(),
        ],
      ),
    );
  }
}

class IndividualBuyCash extends StatelessWidget {
  const IndividualBuyCash({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return ListTile(
      title: Text(player.name),
      subtitle: Text("\$${player.buyIn.toStringAsFixed(2)}"),
      contentPadding: const EdgeInsets.all(0),
      leading: IconButton(
        icon: const Icon(
          Icons.add,
          semanticLabel: 'Add More Funds',
        ),
        color: theme.colorScheme.primary,
        onPressed: player.cashedEarly == true
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return IncreaseBuyIn(player: player);
                  },
                );
              },
      ),
      trailing: ElevatedButton(
        onPressed: player.cashedEarly == true || player.buyIn == 0
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return IndividualCashOut(
                      player: player,
                      remainingPot: appState.getRemainingPot(),
                    );
                  },
                );
              },
        child: player.cashedEarly == false
            ? const Text('Cash Out')
            : Text('\$${player.cashOut.toStringAsFixed(2)}'),
      ),
    );
  }
}
