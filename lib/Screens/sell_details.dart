// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class SellDetails extends StatefulWidget {
  final List<Productmodel> selectedProducts;

  const SellDetails({
    super.key,
    required this.selectedProducts,
  });

  @override
  State<SellDetails> createState() => _SellDetailsState();
}

class _SellDetailsState extends State<SellDetails> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    getsellproduct();
    getallproduct();
    calculateTotalPrice();
  }

  Future<void> getallproduct() async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    final productList = List<Productmodel>.from(productBox.values);
    productListNotifier.value = productList;
    // ignore: invalid_use_of_protected_member
    productListNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Bill Details',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _selectDateRange(context);
            },
          ),
          if (selectedStartDate != null && selectedEndDate != null)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  selectedStartDate = null;
                  selectedEndDate = null;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder<List<SellProduct>>(
              valueListenable: sellListNotifier,
              builder: (context, sellProducts, child) {
                // Filter by selected date range if available
                List<SellProduct> displayedSellProducts = [];
                if (selectedStartDate != null && selectedEndDate != null) {
                  displayedSellProducts = sellProducts.where((sellProduct) {
                    final sellDate = sellProduct.sellDate;
                    return sellDate != null &&
                        sellDate.isAfter(selectedStartDate!) &&
                        sellDate.isBefore(
                            selectedEndDate!.add(const Duration(days: 1)));
                  }).toList();
                } else {
                  displayedSellProducts = sellProducts;
                }

                // Sort the sell products by date (most recent first)
                displayedSellProducts
                    .sort((a, b) => b.sellDate!.compareTo(a.sellDate!));

                if (displayedSellProducts.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: Text(
                        'No sell products available',
                      ),
                    ),
                  );
                }

                return Column(
                  children: displayedSellProducts.map((sellProduct) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20.0),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you want to delete this sell entry?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        setState(() {
                          sellProducts.remove(sellProduct);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Customer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    sellProduct.sellDate != null
                                        ? DateFormat('dd/MM/yyyy \n hh:mm:ss a')
                                            .format(sellProduct.sellDate!)
                                        : 'N/A',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(sellProduct.sellName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(
                                    Icons.call_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    sellProduct.sellPhone,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    'Products ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: () {
                                  Map<String, int> productCountMap = {};
                                  List<String> products =
                                      sellProduct.sellproductname.split(',');

                                  for (String product in products) {
                                    String productName = product.trim();
                                    if (productCountMap
                                        .containsKey(productName)) {
                                      productCountMap[productName] =
                                          (productCountMap[productName] ?? 0) +
                                              1;
                                    } else {
                                      productCountMap[productName] = 1;
                                    }
                                  }
                                  List<Widget> productWidgets = [];
                                  productCountMap
                                      .forEach((productName, productCount) {
                                    Productmodel? product;
                                    for (var element
                                        in productListNotifier.value) {
                                      if (element.productname == productName) {
                                        product = element;
                                        break;
                                      }
                                    }

                                    if (product != null) {
                                      productWidgets.add(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$productName * $productCount = ₹ ${sellProduct.sellPrice}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  });
                                  return productWidgets;
                                }(),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Price:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '₹${sellProduct.sellPrice}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        selectedStartDate = picked.start;
        selectedEndDate = picked.end;
      });
    }
  }
}
