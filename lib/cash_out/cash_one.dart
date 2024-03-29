import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:buy_in_pay_out/app_state.dart';
import '../players/player.dart';

class IndividualCashOut extends StatefulWidget {
  const IndividualCashOut(
      {super.key, required this.player, required this.remainingPot});
  final Player player;
  final double remainingPot;
  @override
  State<IndividualCashOut> createState() => _IndividualCashOutState();
}

class _IndividualCashOutState extends State<IndividualCashOut> {
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
    double remainingPot = widget.remainingPot;

    return AlertDialog(
      title: const Text('Cash Out'),
      actionsAlignment: MainAxisAlignment.center,
      content: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Flexible(
              child: Icon(
                Icons.attach_money_outlined,
                semanticLabel: 'Cash Out',
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                controller: txtController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Input valid cash out. Numbers up to 2 decimals allowed.';
                  }
                  if (double.parse(value) > remainingPot) {
                    return 'Insufficient funds';
                  }
                  return null;
                },
                onFieldSubmitted: (String? value) {
                  if (_formKey.currentState!.validate()) {
                    appState.cashOutEarly(
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
            if (_formKey.currentState!.validate()) {
              appState.cashOutEarly(player, double.parse(txtController.text));
              txtController.clear();
              Navigator.pop(context);
            }
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
