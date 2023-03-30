import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buy_in.dart';
import 'main.dart';

class AddPlayers extends StatefulWidget {
  const AddPlayers({super.key});
  @override
  State<AddPlayers> createState() => _AddPlayersState();
}

class _AddPlayersState extends State<AddPlayers> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final txtController = TextEditingController();
  late FocusNode playerFieldFocusNode;

  @override
  void initState() {
    super.initState();
    playerFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    txtController.dispose();
    playerFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Center(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicBuyIn()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('Buy In'),
              ),
            ],
          ),
          const Text('Add Players'),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  focusNode: playerFieldFocusNode,
                  controller: txtController,
                  decoration:
                      const InputDecoration(hintText: 'Enter player\'s name'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required.';
                    }
                    if (appState.players.singleWhereOrNull(
                            (player) => player.name == value) !=
                        null) {
                      return 'No duplicate names allowed';
                    }
                    return null;
                  },
                  onFieldSubmitted: (String? value) {
                    if (_formKey.currentState!.validate()) {
                      appState.addPlayer(txtController.text);
                      txtController.clear();
                      playerFieldFocusNode.requestFocus();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        appState.addPlayer(txtController.text);
                        txtController.clear();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(playerString(appState.players.length)),
          ),
          for (var player in appState.players)
            ListTile(
              leading: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  semanticLabel: 'Delete',
                ),
                color: theme.colorScheme.primary,
                onPressed: () {
                  appState.removePlayer(player.name);
                },
              ),
              title: Text(player.name),
            )
        ],
      ),
    );
  }
}

String playerString(int num) {
  var verb = num == 1 ? 'is' : 'are';
  var noun = num == 1 ? 'player' : 'players';
  return 'There $verb $num $noun:';
}
