import 'package:flutter/material.dart';

class BuyCash extends StatefulWidget {
  const BuyCash({super.key});

  @override
  State<BuyCash> createState() => _BuyCashState();
}

class _BuyCashState extends State<BuyCash> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy In Cash Out')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Test'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
