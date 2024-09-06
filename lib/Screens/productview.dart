import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

class Productview extends StatefulWidget {
  const Productview({super.key, required String productid});

  @override
  State<Productview> createState() => _ProductviewState();
}

class _ProductviewState extends State<Productview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        backgroundColor: const Color(0xFFE6B0AA),
        title: 'Products View',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE6B0AA), // Top shade color
            Color.fromARGB(255, 130, 200, 122), // Bottom shade color
          ],
        )),
      ),
    );
  }
}
