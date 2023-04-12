import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../buy_cash.dart';
import 'individual.dart';

class BasicBuyIn extends StatefulWidget {
  const BasicBuyIn({super.key});
  @override
  State<BasicBuyIn> createState() => _BasicBuyIn();
}

class _BasicBuyIn extends State<BasicBuyIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Buy In For All Players')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: txtController,
                  decoration: const InputDecoration(
                    hintText: 'Enter buy in for all players',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Input valid buy in. Numbers up to 2 decimals allowed.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (String? value) {
                    if (_formKey.currentState!.validate()) {
                      appState.buyInAll(double.parse(value!));
                      txtController.clear();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        appState.buyInAll(double.parse(txtController.text));
                        txtController.clear();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Buy In Per Player:'),
          ),
          for (var player in appState.players) IndividualBuyIn(player: player),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BuyCash()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Finalize Initial Bets'),
            ),
          ),
        ],
      ),
    );
  }
}
