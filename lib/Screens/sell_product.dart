// ignore: file_names
// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:upsets/Screens/sell_details.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class SellProducts extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SellProducts({
    Key? key,
  });

  @override
  State<SellProducts> createState() => _SellProductsState();
}

class _SellProductsState extends State<SellProducts> {
  final _sellName = TextEditingController();
  final _sellPhone = TextEditingController();
  final _sellchair = TextEditingController();
  final _sellPrice = TextEditingController();
  final _selldiscount = TextEditingController();

  List<Productmodel> selectedProducts = [];
  int totalSoldCount = 0;
  late Future<List<Productmodel>> allProductsFuture;
  late Function(double) updateTodayRevenue;

  @override
  void dispose() {
    _sellName.dispose();
    _sellPhone.dispose();
    _sellchair.dispose();
    _sellPrice.dispose();
    _selldiscount.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    allProductsFuture = getAllProducts();
  }

  Future<List<Productmodel>> getAllProducts() async {
    final addProductBox = await Hive.openBox<Productmodel>('product_db');
    final allProduct = addProductBox.values.toList();
    return List<Productmodel>.from(allProduct);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double totalPrice = selectedProducts.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + double.parse(element.sellingrate.toString()),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE6B0AA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6B0AA),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 35),
          child: Text(
            'Sell Products',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xFFE6B0AA),
                Color.fromARGB(255, 130, 200, 122),
              ])),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _sellName,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _sellPhone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          maxLines: null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Choose Product',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _navigateAndDisplaySelection(context);
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                          readOnly: true,
                          controller: _sellchair,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose a product';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          readOnly: true,
                          controller: _sellPrice,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final newSellproduct = SellProduct(
                                    sellName: _sellName.text,
                                    sellPhone: _sellPhone.text,
                                    sellproductname: selectedProducts
                                        .map((e) => e.productname)
                                        .join(', '),
                                    sellPrice: totalPrice.toString(),
                                    sellDate: DateTime?.now(),
                                    sellDiscount: _selldiscount.text,
                                  );

                                  for (var product in selectedProducts) {
                                    if (product.stock != null &&
                                        product.stock! > 0) {
                                      product.stock = product.stock! - 1;
                                      await updateProduct(product);
                                    }
                                  }

                                  await addSellProduct(newSellproduct);

                                  setState(() {
                                    totalSoldCount += selectedProducts.length;
                                  });

                                  updateTotalSoldCount(selectedProducts.length);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SellDetails(
                                              selectedProducts:
                                                  selectedProducts)));

                                  setState(() {
                                    _sellName.clear();
                                    _sellPhone.clear();
                                    _sellchair.clear();
                                    _sellPrice.clear();
                                    _selldiscount.clear();
                                  });
                                } catch (e) {
                                  // ignore: avoid_print
                                  print('An error occurred: $e');
                                }
                              }
                            },
                            child: const Text(
                              'Sell',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 241, 141, 141)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateTotalSoldCount(int count) {
    setState(() {
      totalSoldCount += count;
    });
  }

  Future<void> updateProduct(Productmodel product) async {
    try {
      final productBox = await Hive.openBox<Productmodel>('product_db');
      await productBox.put(product.id, product);
    } catch (e) {
      // ignore: avoid_print
      print('Error updating product: $e');
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await showDialog<List<Productmodel>>(
      context: context,
      builder: (BuildContext context) {
        return ProductSelectionScreen();
      },
    );

    if (result != null) {
      setState(() {
        selectedProducts = result;
        _sellchair.text = '';
        double totalPrice = 0;
        Map<String, int> productCounts = {};

        for (var product in selectedProducts) {
          totalPrice += double.parse(product.sellingrate.toString());
          if (productCounts.containsKey(product.productname)) {
            productCounts[product.productname.toString()] =
                productCounts[product.productname]! + 1;
          } else {
            productCounts[product.productname.toString()] = 1;
          }
        }

        for (var entry in productCounts.entries) {
          String productName = entry.key;
          int count = entry.value;
          double productPrice = double.parse(selectedProducts
                  .firstWhere((p) => p.productname == productName)
                  .sellingrate
                  .toString()) *
              count;

          _sellPrice.text = totalPrice.toString();
          _sellchair.text +=
              '$productName (x$count) - ${productPrice.toStringAsFixed(2)}\n';
        }
      });
    }
  }
}

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  List<Productmodel> allProducts = [];
  List<Productmodel> displayedProducts = [];
  List<int> selectedCounts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final addProductBox = await Hive.openBox<Productmodel>('product_db');
    setState(() {
      allProducts = addProductBox.values.toList();
      displayedProducts = allProducts;
      selectedCounts = List.generate(displayedProducts.length, (index) => 0);
    });
  }

  void filterProducts(String query) {
    final filteredProducts = allProducts.where((product) {
      final productName = product.productname!.toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedProducts = filteredProducts;
      selectedCounts = List.generate(displayedProducts.length, (index) => 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF2E8CD),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: filterProducts,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  Productmodel product = displayedProducts[index];
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        // Open count dialog only if in stock
                        if (product.stock! > 0) {
                          _openCountDialog(context, index);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.productname!),
                          if (product.stock! <= 0)
                            const Text(
                              'Out of Stock',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(selectedCounts[index].toString()),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      List<Productmodel> selectedProducts = [];
                      for (int i = 0; i < displayedProducts.length; i++) {
                        for (int j = 0; j < selectedCounts[i]; j++) {
                          selectedProducts.add(displayedProducts[i]);
                        }
                      }
                      Navigator.pop(context, selectedProducts);
                    },
                    child: const Text('Add'),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedCounts =
                            List.generate(allProducts.length, (_) => 0);
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCountDialog(BuildContext context, int index) {
    int count = selectedCounts[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text('Select Count for ${displayedProducts[index].productname}'),
          content: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (count > 0) {
                    setState(() {
                      count--;
                      selectedCounts[index] = count;
                    });
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              Text(count.toString()),
              IconButton(
                onPressed: () {
                  if (displayedProducts[index].stock! > count) {
                    setState(() {
                      count++;
                      selectedCounts[index] = count;
                    });
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCounts[index] = count;
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
