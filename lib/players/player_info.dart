import 'package:flutter/material.dart';
import 'player.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var name = player.name;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(name),
        // subtitle: Distribute(transactions: player.transactions),
        controlAffinity: ListTileControlAffinity.leading,
        leading: Icon(
          Icons.info_outline,
          color: theme.primaryColor,
        ),
        children: <Widget>[
          ListTile(
            title: Text(
                'Buy In: \$${player.buyIn.toStringAsFixed(2)}  Cash Out: \$${player.cashOut.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
