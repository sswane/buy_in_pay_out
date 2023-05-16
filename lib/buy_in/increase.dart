import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../players/player.dart';

class IncreaseBuyIn extends StatefulWidget {
  const IncreaseBuyIn({super.key, required this.player});
  final Player player;
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
                keyboardType: TextInputType.number,
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
        ),
      ],
    );
  }
}
