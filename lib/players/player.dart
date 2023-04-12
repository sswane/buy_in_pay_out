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

  void clearTransactions() {
    transactions = [];
  }
}

class Transaction {
  Player player;
  double num;

  Transaction({required this.player, required this.num});
}
