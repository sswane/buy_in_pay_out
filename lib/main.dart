import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_players.dart';

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

class Player {
  String name;
  double buyIn;
  double cashOut;
  bool cashedEarly;

  Player(
      {required this.name,
      this.buyIn = 0,
      this.cashOut = 0,
      this.cashedEarly = false});
}

class MyAppState extends ChangeNotifier {
  List<Player> players = [];

  void addPlayer(String name) {
    players.add(Player(name: name));
    notifyListeners();
  }

  void removePlayer(Player player) {
    players.remove(player);
    notifyListeners();
  }

  void buyInAll(double num) {
    for (var player in players) {
      player.buyIn = num;
    }
    notifyListeners();
  }

  void editPlayerBuyIn(Player player, double num) {
    player.buyIn = num;
    notifyListeners();
  }

  void addToPlayerBuyIn(Player player, double num) {
    player.buyIn = num + player.buyIn;
    notifyListeners();
  }

  void cashOutPlayer(Player player, double num) {
    player.cashOut = num;
    notifyListeners();
  }

  void cashOutEarly(Player player, double num) {
    player.cashedEarly = true;
    cashOutPlayer(player, num);
  }
}
