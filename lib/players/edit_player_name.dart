import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../players/player.dart';

class EditPlayerName extends StatefulWidget {
  const EditPlayerName({super.key, required this.player});
  final Player player;
  @override
  State<EditPlayerName> createState() => _EditPlayerNameState();
}

class _EditPlayerNameState extends State<EditPlayerName> {
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
      title: const Text('Edit Player Name'),
      actionsAlignment: MainAxisAlignment.center,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              controller: txtController,
              decoration: const InputDecoration(
                  hintText: 'Enter name',
                  icon: Icon(
                    Icons.person,
                    semanticLabel: 'Add Player',
                  )),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required.';
                }
                if (appState.players
                        .singleWhereOrNull((player) => player.name == value) !=
                    null) {
                  return 'No duplicate names allowed';
                }
                return null;
              },
              onFieldSubmitted: (String? value) {
                if (_formKey.currentState!.validate()) {
                  appState.editPlayerName(player, txtController.text);
                  txtController.clear();
                  Navigator.pop(context);
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
              appState.editPlayerName(player, txtController.text);
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
  }
}
