import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 220, 220),
      appBar: AppBar(
        title: const Text('Overview'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 227, 220, 220),
      ),
    );
  }
}
