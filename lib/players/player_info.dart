import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'player.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var name = player.name;

    return Row(
      children: [
        InfoPopupWidget(
          arrowTheme: InfoPopupArrowTheme(color: theme.primaryColor),
          contentTitle:
              "Buy In: \$${player.buyIn.toStringAsFixed(2)}, Cash Out: \$${player.cashOut.toStringAsFixed(2)}",
          contentTheme: InfoPopupContentTheme(
              infoContainerBackgroundColor: theme.colorScheme.primary,
              infoTextStyle: TextStyle(color: theme.colorScheme.onPrimary)),
          child: Icon(Icons.info_outline, color: theme.primaryColor),
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(name),
      ],
    );
  }
}
