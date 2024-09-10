// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class Productdetail extends StatelessWidget {
  final Productmodel data;
  const Productdetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      body: SingleChildScrollView(
        // Added scroll functionality
        child: SizedBox(
          height: screenHeight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.file(
                      File(data.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Product Name: ${data.productname}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Category: ${data.categoryname.toString()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Selling Rate: ₹ ${data.sellingrate.toString()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Purchase Rate: ₹ ${data.purchaserate.toString()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Available Stock: ${data.stock.toString()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.description!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 20), // Added padding to the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
