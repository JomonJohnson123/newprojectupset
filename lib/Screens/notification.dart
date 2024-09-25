import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart'; // Ensure you import your models and database functions

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
        context: context,
      ),
      body: ValueListenableBuilder<List<Productmodel>>(
        valueListenable:
            productListNotifier, // Listen to the product list notifier
        builder: (context, productList, _) {
          // Filter out-of-stock products
          final outOfStockProducts =
              productList.where((product) => product.stock! <= 0).toList();

          if (outOfStockProducts.isEmpty) {
            return Center(child: const Text('No out-of-stock items.'));
          }

          return ListView.builder(
            itemCount: outOfStockProducts.length,
            itemBuilder: (context, index) {
              final product = outOfStockProducts[index];
              return ListTile(
                title: Text('Product: ${product.productname}'),
                subtitle: Text('Category: ${product.categoryname}'),
                trailing: Text('Stock: ${product.stock}'),
              );
            },
          );
        },
      ),
    );
  }
}
