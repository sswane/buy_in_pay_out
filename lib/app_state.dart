import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'players/player.dart';

class MyAppState extends ChangeNotifier {
  List<Player> players = [];
  List<Player> winners = [];
  List<Player> losers = [];

  double getTotalPot() {
    return players.fold(0, (total, p) => total + p.buyIn);
  }

  double getRemainingPot() {
    return getTotalPot() - players.fold(0.0, (total, p) => total + p.cashOut);
  }

  void addPlayer(String name) {
    players.add(Player(name: name));
    notifyListeners();
  }

  void addPlayerMidGame(String name, double buyIn) {
    players.add(Player.midGame(name: name, buyIn: buyIn));
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

  void clearAllTransactions() {
    for (var player in players) {
      player.clearTransactions();
    }
  }

  void calculateTransactions(List<Player> players) {
    // transactions need cleared if back button used
    // possibly refactor back button on that page?
    clearAllTransactions();
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
