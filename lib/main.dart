import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'buy_in.dart';

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
          body: const MainBody(),
        ),
      ),
    );
  }
}

// Going to come back to this...
class MainBody extends StatefulWidget {
  const MainBody({super.key});
  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const AddPlayers();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Center(child: page);
  }
}

class PlayerBet {
  String name;
  double bet;

  PlayerBet({required this.name, required this.bet});
}

class MyAppState extends ChangeNotifier {
  List<PlayerBet> playersBets = [];

  void addPlayer(String name) {
    playersBets.add(PlayerBet(name: name, bet: 0));
    notifyListeners();
  }

  void removePlayer(String name) {
    playersBets.removeWhere((element) => element.name == name);
    notifyListeners();
  }

  void buyInAll(double num) {
    for (var player in playersBets) {
      player.bet = num;
    }
    notifyListeners();
  }

  void editPlayerBet(PlayerBet player, double num) {
    var p = playersBets.singleWhere((element) => element.name == player.name);
    p.bet = num;
    notifyListeners();
  }
}

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
                    if (appState.playersBets.singleWhereOrNull(
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
            child: Text(playerString(appState.playersBets.length)),
          ),
          for (var player in appState.playersBets)
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
