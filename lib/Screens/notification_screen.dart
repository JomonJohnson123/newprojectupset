import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 177, 177),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 177, 177),
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }
}
