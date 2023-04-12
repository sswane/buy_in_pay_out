import 'package:buy_in_pay_out/players/list_players.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buy_in/basic.dart';
import 'players/add_player.dart';
import 'app_state.dart';

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

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
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
          const AddPlayer(),
          const ListPlayers(),
        ],
      ),
    );
  }
}
