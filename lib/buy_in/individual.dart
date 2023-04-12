import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../players/player.dart';

class IndividualBuyIn extends StatefulWidget {
  const IndividualBuyIn({super.key, required this.player});
  final Player player;
  @override
  State<IndividualBuyIn> createState() => _IndividualBuyInState();
}

class _IndividualBuyInState extends State<IndividualBuyIn> {
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
    var theme = Theme.of(context);
    var player = widget.player;

    return ListTile(
      subtitle: Text("\$${player.buyIn.toStringAsFixed(2)}"),
      title: Text(player.name),
      leading: IconButton(
        icon: const Icon(
          Icons.edit_outlined,
          semanticLabel: 'Edit Buy In',
        ),
        color: theme.colorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Edit individual bet'),
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
                                appState.editPlayerBuyIn(
                                    player, double.parse(txtController.text));
                                txtController.clear();
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ]),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        appState.editPlayerBuyIn(
                            player, double.parse(txtController.text));
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
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
