import 'package:flutter/material.dart';

class SellDetails extends StatelessWidget {
  const SellDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 185, 185),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 220, 220),
        title: const Text('Sell Details'),
      ),
      body: const Center(child: Text('Sell Details')),
    );
  }
}
