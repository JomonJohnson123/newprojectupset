// ignore: file_names
// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:upsets/Screens/sell_details.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class SellProducts extends StatefulWidget {
  const SellProducts({Key? key});

  @override
  State<SellProducts> createState() => _SellProductsState();
}

class _SellProductsState extends State<SellProducts> {
  final _sellName = TextEditingController();
  final _sellPhone = TextEditingController();
  final _sellchair = TextEditingController();
  final _sellPrice = TextEditingController();
  final _selldiscount = TextEditingController();
  bool _isProductSelected = false;
  List<Productmodel> selectedProducts = [];
  int totalSoldCount = 0;
  late Future<List<Productmodel>> allProductsFuture;

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
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 222, 222, 222),
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
                Color.fromARGB(255, 222, 222, 222),
                Color.fromARGB(255, 222, 222, 222),
              ],
            ),
          ),
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
                        kheight30,
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
                        kheight30,
                        TextFormField(
                          maxLines: null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Choose Product',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 48,
                              minHeight: 48,
                            ),
                            suffixIcon: _isProductSelected
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _sellchair.clear();
                                        _isProductSelected = false;
                                      });
                                    },
                                  )
                                : IconButton(
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
                        kheight30,
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
                        kheight30,
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
                                    totalprice: null,
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

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SellDetails(
                                          selectedProducts: selectedProducts),
                                    ),
                                  );

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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 95, 89, 89)),
                              shape: WidgetStateProperty.all<
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
      print('Error updating product: $e');
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await showDialog<List<Productmodel>>(
      context: context,
      builder: (BuildContext context) {
        return const ProductSelectionScreen();
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
          if (_sellchair.text.isNotEmpty) {
            _sellchair.text += ', ';
          }
          _sellchair.text += '$productName($count)';
        }

        _sellPrice.text = totalPrice.toString();
        _isProductSelected = true;
      });
    }
  }
}

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  _ProductSelectionScreenState createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  List<Productmodel> products = [];
  List<Productmodel> filteredProducts = [];
  Map<Productmodel, int> selectedProductCounts = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final addProductBox = await Hive.openBox<Productmodel>('product_db');
    setState(() {
      products = List<Productmodel>.from(addProductBox.values);
      filteredProducts = products;
    });
  }

  void _onSearchTextChanged(String searchText) {
    setState(() {
      filteredProducts = products.where((product) {
        final productName = product.productname!.toLowerCase();
        final searchLower = searchText.toLowerCase();
        return productName.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: _onSearchTextChanged,
              decoration: const InputDecoration(
                labelText: 'Search Products',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final count = selectedProductCounts[product] ?? 0;

                  // Provide a fallback value for null product names
                  final productName = product.productname ?? 'Unknown Product';

                  return Card(
                    child: ListTile(
                      title: Text(productName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Check if the stock is zero and display "Out of Stock" or stock amount
                          product.stock == 0
                              ? const Text(
                                  'Out of Stock',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Stock: ${product.stock}'),
                                    const SizedBox(height: 4.0),
                                    Text('Price: ₹${product.sellingrate}'),
                                  ],
                                ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (count > 0) {
                                setState(() {
                                  selectedProductCounts[product] = count - 1;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(count.toString()),
                          IconButton(
                            onPressed: () {
                              // Ensure the count does not exceed stock and is greater than zero
                              if (product.stock != null &&
                                  product.stock! > 0 &&
                                  count < product.stock!) {
                                setState(() {
                                  selectedProductCounts[product] = count + 1;
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 219, 42, 30), // Cancel button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context); // Closes the dialog without action
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 0, 0, 0), // Done button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      final selectedProducts = <Productmodel>[];
                      selectedProductCounts.forEach((product, count) {
                        if (count > 0) {
                          for (int i = 0; i < count; i++) {
                            selectedProducts.add(product);
                          }
                        }
                      });
                      Navigator.pop(context, selectedProducts);
                    },
                    child: const Text('Done',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
