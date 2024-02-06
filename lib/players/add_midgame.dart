import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class AddPlayerMidGame extends StatefulWidget {
  const AddPlayerMidGame({super.key});

  @override
  State<StatefulWidget> createState() => _AddPlayerMidGameState();
}

class _AddPlayerMidGameState extends State<AddPlayerMidGame> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final playerTxtCtrl = TextEditingController();
  final buyInTxtCtrl = TextEditingController();
  late FocusNode playerFieldFocusNode;
  late FocusNode buyInFieldFocusNode;

  @override
  void initState() {
    super.initState();
    playerFieldFocusNode = FocusNode();
    buyInFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    playerTxtCtrl.dispose();
    buyInTxtCtrl.dispose();
    playerFieldFocusNode.dispose();
    buyInFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return AlertDialog(
      title: const Text('Add Player'),
      actionsAlignment: MainAxisAlignment.center,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              focusNode: playerFieldFocusNode,
              controller: playerTxtCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  hintText: 'Enter name',
                  icon: Icon(
                    Icons.person,
                    semanticLabel: 'Add Player',
                  )),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  playerFieldFocusNode.requestFocus();
                  return 'Name is required.';
                }
                if (appState.players
                        .singleWhereOrNull((player) => player.name == value) !=
                    null) {
                  playerFieldFocusNode.requestFocus();
                  return 'No duplicate names allowed';
                }
                return null;
              },
              onFieldSubmitted: (String? value) {
                if (_formKey.currentState!.validate()) {
                  appState.addPlayerMidGame(
                      playerTxtCtrl.text, double.parse(buyInTxtCtrl.text));
                  playerTxtCtrl.clear();
                  buyInTxtCtrl.clear();
                  // should we leave this open here?
                  Navigator.pop(context);
                }
              },
            ),
            TextFormField(
              autofocus: true,
              focusNode: buyInFieldFocusNode,
              controller: buyInTxtCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Enter buy in',
                  icon: Icon(
                    Icons.attach_money_outlined,
                    semanticLabel: 'Buy In',
                  )),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    double.parse(value) == 0) {
                  buyInFieldFocusNode.requestFocus();
                  return 'Invalid amount';
                }
                return null;
              },
              onFieldSubmitted: (String? value) {
                if (_formKey.currentState!.validate()) {
                  appState.addPlayerMidGame(
                      playerTxtCtrl.text, double.parse(buyInTxtCtrl.text));
                  playerTxtCtrl.clear();
                  buyInTxtCtrl.clear();
                  // Could close this or leave open
                  Navigator.pop(context);
                  // playerFieldFocusNode.requestFocus();
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              appState.addPlayerMidGame(
                  playerTxtCtrl.text, double.parse(buyInTxtCtrl.text));
              playerTxtCtrl.clear();
              buyInTxtCtrl.clear();
              // should we leave this open here?
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
        ElevatedButton(
          onPressed: () {
            playerTxtCtrl.clear();
            buyInTxtCtrl.clear();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
