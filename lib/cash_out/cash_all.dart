import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../payout/determine_payout.dart';
import '../players/player_info.dart';
import '../pot.dart';

class CashAllOut extends StatefulWidget {
  const CashAllOut({super.key});
  @override
  State<CashAllOut> createState() => _CashAllOutState();
}

class _CashAllOutState extends State<CashAllOut> {
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Input Remaining Funds')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            DeterminePayout(),
          ]),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var player in appState.players)
                  Row(
                    children: [
                      Flexible(child: PlayerInfo(player: player)),
                      SizedBox(
                        width: 115,
                        child: player.cashedEarly
                            ? DisplayCashedEarly(
                                cashOut: player.cashOut,
                              )
                            : TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  hintText: 'Cash Out',
                                  icon: Icon(
                                    Icons.attach_money_outlined,
                                    semanticLabel: 'Cash Out',
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                onChanged: (text) {
                                  appState.cashOutPlayer(player,
                                      text.isEmpty ? 0 : double.parse(text));
                                },
                              ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                    ],
                  ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          const Pot(),
        ],
      ),
    );
  }
}

class DisplayCashedEarly extends StatelessWidget {
  const DisplayCashedEarly({super.key, required this.cashOut});
  final double cashOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Text(
          '\$${cashOut.toStringAsFixed(2)}',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
