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

  // likely remove this
  void findBrokeEven() {
    for (var player in players) {
      if (player.payout == 0 && player.transactions.isEmpty) {
        debugPrint('${player.name} broke even');
      }
    }
  }

  // players a & b can exchange exact amounts
  void direct(Player a, Player b) {
    a.transactions.add(Transaction(player: b, num: a.payout));
    b.transactions.add(Transaction(player: a, num: b.payout));
    a.setPayout(0);
    b.setPayout(0);
    debugPrint('${a.name} directly matches ${b.name}');
  }

  // player a is paid by player b
  void oneWay(Player a, Player b) {
    a.transactions.add(Transaction(player: b, num: b.payout.abs()));
    b.transactions.add(Transaction(player: a, num: b.payout));
    a.setPayout(a.payout + b.payout);
    b.setPayout(0);
    debugPrint('${a.name} can be fully paid by ${b.name}');
  }

  // player a pays player b
  void otherWay(Player a, Player b) {
    a.transactions.add(Transaction(player: b, num: -b.payout));
    b.transactions.add(Transaction(player: a, num: b.payout));
    a.setPayout(0);
    b.setPayout(b.payout - b.payout);
    debugPrint('${a.name} can fully pay ${b.name}');
  }

  // player a is paid by player b when remaining
  void special(Player a, Player b) {
    a.transactions.add(Transaction(player: b, num: a.payout));
    b.transactions.add(Transaction(player: a, num: -a.payout));
    b.setPayout(b.payout + a.payout);
    a.setPayout(0);
    debugPrint('${a.name} has now been fully paid out, last by ${b.name}');
  }

  void splitPlayers() {
    winners = players.where((p) => p.payout > 0).toList();
    losers = players.where((p) => p.payout < 0).toList();
    debugPrint('total winners: ${winners.length}');
    debugPrint('total losers: ${losers.length}');
  }

  void calculateTransactions(List<Player> players) {
    debugPrint('total players: ${players.length}');

    // Find players who broke even, should not pay or be paid
    findBrokeEven();
    // Split into winners & losers
    splitPlayers();

    // Find players where one owes the exact amount one is due
    for (var i = 0; i < winners.length; i++) {
      debugPrint('winner looking for direct: ${winners[i].name}');
      var match =
          losers.firstWhereOrNull((p) => p.payout + winners[i].payout == 0);
      if (match != null) {
        direct(winners[i], match);
        losers.remove(match);
      }
    }
    winners.removeWhere((p) => p.payout == 0);

    debugPrint('winners after direct: ${winners.length}');
    debugPrint('losers after direct: ${losers.length}');

    winners.sort((p1, p2) => p2.payout.compareTo(p1.payout));
    losers.sort((p1, p2) => p2.payout.compareTo(p1.payout));

    // lowest loser could directly pay the highest winner
    if (losers.isNotEmpty &&
        winners.isNotEmpty &&
        winners.first.payout + losers.first.payout >= 0) {
      for (var i = 0; i < winners.length; i++) {
        debugPrint('winner before one way: ${winners[i].name}');
        while (winners[i].payout > 0) {
          var match =
              losers.lastWhereOrNull((p) => p.payout + winners[i].payout >= 0);
          if (match != null) {
            oneWay(winners[i], match);
            losers.remove(match);
          } else {
            debugPrint('${winners[i].name} needs more money');
            if (losers.length == 1) {
              special(winners[i], losers.first);
              losers.removeWhere((p) => p.payout == 0);
            }
            break;
          }
        }
      }
      winners.removeWhere((p) => p.payout == 0);
      debugPrint('winners after one way: ${winners.length}');
      debugPrint('losers after one way: ${losers.length}');
    }

    // Is the rest of this even needed??? Is there more needed after?

    //   losers.sort((p1, p2) => p1.payout.compareTo(p2.payout));

    //   if (losers.isNotEmpty &&
    //       winners.isNotEmpty &&
    //       losers.last.payout + winners.last.payout <= 0) {
    //     // biggest loser could directly pay lowest winner
    //     for (var i = 0; i < losers.length; i++) {
    //       debugPrint('loser before other way: ${losers[i].name}');
    //       debugPrint(losers[i].payout.toStringAsFixed(2));
    //       while (losers[i].payout < 0) {
    //         debugPrint(losers[i].payout.toStringAsFixed(2));
    //         var match =
    //             winners.firstWhereOrNull((p) => p.payout + losers[i].payout <= 0);
    //         if (match != null) {
    //           otherWay(losers[i], match);
    //           winners.remove(match);
    //         } else {
    //           debugPrint('${losers[i].name} needs to pay out more money');
    //           if (winners.length == 1) {
    //             special(losers[i], winners.first);
    //             winners.removeWhere((p) => p.payout == 0);
    //           }
    //           break;
    //         }
    //       }
    //     }
    //     losers.removeWhere((p) => p.payout == 0);

    //     debugPrint('winners after other way: ${winners.length}');
    //     debugPrint('losers after other way: ${losers.length}');
    //   }
  }
}
