import 'package:flutter/material.dart';
import 'package:upsets/Screens/addnewproducts.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

class Productspage extends StatefulWidget {
  const Productspage({super.key});

  @override
  State<Productspage> createState() => _ProductspageState();
}

class _ProductspageState extends State<Productspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          context: context,
          backgroundColor: Colors.white,
          title: 'Products',
          onBackPressed: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewProductsPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
