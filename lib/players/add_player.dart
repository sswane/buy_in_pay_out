import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});
  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(hintText: 'Enter player\'s name'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    playerFieldFocusNode.requestFocus();
                    return 'Name is required';
                  }
                  if (appState.players.singleWhereOrNull(
                          (player) => player.name == value.trim()) !=
                      null) {
                    playerFieldFocusNode.requestFocus();
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
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      appState.addPlayer(txtController.text);
                      txtController.clear();
                      playerFieldFocusNode.requestFocus();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
