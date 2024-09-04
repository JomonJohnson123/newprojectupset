import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

class AddNewProductsPage extends StatefulWidget {
  const AddNewProductsPage({super.key});

  @override
  State<AddNewProductsPage> createState() => _AddNewProductsPageState();
}

class _AddNewProductsPageState extends State<AddNewProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          context: context,
          backgroundColor: Colors.white,
          title: 'Add New Products',
          onBackPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
