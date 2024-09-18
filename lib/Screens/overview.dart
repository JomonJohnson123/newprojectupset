import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 227, 220, 220),
        appBar: CustomAppBar(
            backgroundColor: Colors.white,
            title: 'Overview',
            onBackPressed: () => Navigator.pop(context),
            context: context),
        body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Center(
                        child: Text(
                      'No Products',
                    ))))));
  }
}
