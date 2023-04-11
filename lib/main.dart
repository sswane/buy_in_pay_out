import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
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

class Transaction {
  Player player;
  double num;

  Transaction({required this.player, required this.num});
}

class Player {
  String name;
  double buyIn;
  double cashOut;
  bool cashedEarly;
  double payout;
  List<Transaction> transactions = [];

  Player({
    required this.name,
    this.buyIn = 0,
    this.cashOut = 0,
    this.cashedEarly = false,
    this.payout = 0,
  });

  void setPayout(double newPayout) {
    payout = newPayout;
  }
}

class MyAppState extends ChangeNotifier {
  List<Player> players = [];
  List<Player> winners = [];
  List<Player> losers = [];

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

  void payout() {
    for (var player in players) {
      player.setPayout(player.cashOut - player.buyIn);
    }
    notifyListeners();
  }

  void printBrokeEven() {
    for (var player in players) {
      if (player.payout == 0 && player.transactions.isEmpty) {
        debugPrint('${player.name} broke even');
      }
    }
  }

  void splitPlayers() {
    winners = players.where((p) => p.payout > 0).toList();
    losers = players.where((p) => p.payout < 0).toList();
    debugPrint('winners: ${winners.length}');
    debugPrint('losers: ${losers.length}');
  }

  // call when player a is paid out all owed
  void fullPayment(Player a, Player b) {
    debugPrint(
        '${b.name} pays \$${a.payout.toStringAsFixed(2)} to ${a.name} which was all owed');
    a.transactions.add(Transaction(player: b, num: a.payout));
    b.transactions.add(Transaction(player: a, num: -a.payout));
    b.setPayout(b.payout + a.payout);
    a.setPayout(0);
  }

  // player a is paid by player b but is still owed money
  void partialPayment(Player a, Player b) {
    debugPrint(
        '${b.name} owes \$${b.payout.abs().toStringAsFixed(2)} and pays all to ${a.name}');
    a.transactions.add(Transaction(player: b, num: b.payout.abs()));
    b.transactions.add(Transaction(player: a, num: b.payout));
    a.setPayout(a.payout + b.payout);
    b.setPayout(0);
  }

  void calculateTransactions(List<Player> players) {
    debugPrint('total players: ${players.length}');
    // Find players who broke even, should not pay or be paid
    if (kDebugMode) {
      printBrokeEven();
    }
    // Split into winners & losers
    splitPlayers();

    // Find players where one owes the exact amount one is due
    for (var winner in winners) {
      debugPrint('winner looking for direct: ${winner.name}');
      var match = losers.firstWhereOrNull((p) => p.payout + winner.payout == 0);
      if (match != null) {
        fullPayment(winner, match);
        losers.remove(match);
      }
    }
    winners.removeWhere((p) => p.payout == 0);

    debugPrint('winners after direct: ${winners.length}');
    debugPrint('losers after direct: ${losers.length}');

    winners.sort((p1, p2) => p2.payout.compareTo(p1.payout));
    losers.sort((p1, p2) => p2.payout.compareTo(p1.payout));

    while (losers.isNotEmpty && winners.isNotEmpty) {
      for (var winner in winners) {
        debugPrint('winner looking for payment: ${winner.name}');
        while (winner.payout > 0) {
          if (losers.length == 1) {
            fullPayment(winner, losers.first);
            losers.removeWhere((p) => p.payout == 0);
            break;
          }
          var match =
              losers.lastWhereOrNull((p) => p.payout + winner.payout >= 0);
          if (match != null) {
            partialPayment(winner, match);
            losers.remove(match);
          } else {
            debugPrint('${winner.name} needs more money');
            break;
          }
        }
      }
      winners.removeWhere((p) => p.payout == 0);
      debugPrint('winners: ${winners.length}');
      debugPrint('losers: ${losers.length}');
    }
  }
}
