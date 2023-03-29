import 'package:buy_in_pay_out/cash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Cash All Out'),
            ),
          ]),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var player in appState.playersBets)
                  IndividualBuyCash(
                    player: player,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IncreaseBuyIn extends StatefulWidget {
  const IncreaseBuyIn({super.key, required this.player});
  final PlayerBet player;
  @override
  State<IncreaseBuyIn> createState() => _IncreaseBuyInState();
}

class _IncreaseBuyInState extends State<IncreaseBuyIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var player = widget.player;

    return AlertDialog(
      title: const Text('Increase Buy In'),
      actionsAlignment: MainAxisAlignment.center,
      content: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Flexible(
              child: Icon(
                Icons.attach_money_outlined,
                semanticLabel: 'Buy In',
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                controller: txtController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Input valid buy in. Numbers up to 2 decimals allowed.';
                  }
                  return null;
                },
                onFieldSubmitted: (String? value) {
                  if (_formKey.currentState!.validate()) {
                    appState.addToPlayerBuyIn(
                        player, double.parse(txtController.text));
                    txtController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            appState.addToPlayerBuyIn(player, double.parse(txtController.text));
            txtController.clear();
            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
        ElevatedButton(
          onPressed: () {
            txtController.clear();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        )
      ],
    );
  }
}

class IndividualBuyCash extends StatelessWidget {
  const IndividualBuyCash({super.key, required this.player});
  final PlayerBet player;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListTile(
      title: Text(player.name),
      subtitle: Text("\$${player.buyIn.toStringAsFixed(2)}"),
      leading: IconButton(
        icon: const Icon(
          Icons.add,
          semanticLabel: 'Add More Funds',
        ),
        color: theme.colorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return IncreaseBuyIn(player: player);
            },
          );
        },
      ),
      trailing: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return IndividualCashOut(player: player);
            },
          );
        },
        child: const Text('Cash Out'),
      ),
    );
  }
}
