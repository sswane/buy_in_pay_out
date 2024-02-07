import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../players/edit_player_name.dart';

class ListPlayers extends StatelessWidget {
  const ListPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(playerString(appState.players.length)),
        ),
        for (var player in appState.players.reversed)
          ListTile(
            leading: Wrap(children: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  semanticLabel: 'Delete',
                ),
                color: theme.colorScheme.primary,
                onPressed: () {
                  appState.removePlayer(player);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  semanticLabel: 'Edit',
                ),
                color: theme.colorScheme.primary,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditPlayerName(
                        player: player,
                      );
                    },
                  );
                },
              ),
            ]),
            title: Text(player.name),
          ),
      ],
    );
  }
}

String playerString(int num) {
  var verb = num == 1 ? 'is' : 'are';
  var noun = num == 1 ? 'player' : 'players';
  return 'There $verb $num $noun:';
}
