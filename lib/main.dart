import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Buy In Pay Out',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Buy In Pay Out')),
          body: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var players = <String>[];

  void addPlayer(String name) {
    players.add(name);
    notifyListeners();
  }

  void removePlayer(String name) {
    players.remove(name);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                onPressed: () {},
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
                    if (appState.players.contains(value)) {
                      return 'No duplicate names allowed.';
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
                  appState.removePlayer(player);
                },
              ),
              title: Text(player),
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
