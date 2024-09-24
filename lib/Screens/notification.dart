import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backgroundColor: Colors.white,
          iconColor: Colors.black,
          title: 'Notifications',
          onBackPressed: () => Navigator.pop(context),
          context: context),
    );
  }
}
