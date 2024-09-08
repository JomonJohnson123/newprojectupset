import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/appbars.dart'; // Ensure this is implemented correctly

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
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
          ),
        ),
      ),
    );
  }
}
