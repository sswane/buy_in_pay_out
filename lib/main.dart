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

class PlayerBet {
  String name;
  double buyIn;
  double cashOut;

  PlayerBet({required this.name, required this.buyIn, this.cashOut = 0});
}

class MyAppState extends ChangeNotifier {
  List<PlayerBet> playersBets = [];

  void addPlayer(String name) {
    playersBets.add(PlayerBet(name: name, buyIn: 0));
    notifyListeners();
  }

  void removePlayer(String name) {
    playersBets.removeWhere((element) => element.name == name);
    notifyListeners();
  }

  void buyInAll(double num) {
    for (var player in playersBets) {
      player.buyIn = num;
    }
    notifyListeners();
  }

  void editPlayerBuyIn(PlayerBet player, double num) {
    var p = playersBets.singleWhere((element) => element.name == player.name);
    p.buyIn = num;
    notifyListeners();
  }

  void addToPlayerBuyIn(PlayerBet player, double num) {
    var p = playersBets.singleWhere((element) => element.name == player.name);
    p.buyIn = num + p.buyIn;
    notifyListeners();
  }

  void cashOutPlayer(PlayerBet player, double num) {
    var p = playersBets.singleWhere((element) => element.name == player.name);
    p.cashOut = num;
    notifyListeners();
  }
}
