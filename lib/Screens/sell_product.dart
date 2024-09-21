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

                                    // print('Total Sold Count: $totalSoldCount');
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
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 241, 141, 141)),
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
                  .firstWhere((product) => product.productname == productName)
                  .sellingrate
                  .toString()) *
              count;
          String formattedProduct =
              '$productName = $count * ${selectedProducts.firstWhere((product) => product.productname == productName).sellingrate} = $productPrice';
          // ignore: prefer_interpolation_to_compose_strings
          _sellchair.text += formattedProduct + '\n';
        }

        _sellPrice.text = totalPrice.toString();
      });
    }
  }
}

// ignore: use_key_in_widget_constructors
class ProductSelectionScreen extends StatefulWidget {
  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();

  void onUpdateSelectedProducts(List<Productmodel> selectedProducts) {}

  void onUpdateReturnName(param0) {}

  void onUpdateReturnPhone(param0) {}
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  late List<Productmodel> allProducts;
  late List<Productmodel> displayedProducts = [];
  late List<int> selectedCounts = [];

  @override
  void initState() {
    super.initState();
    getAllProducts().then((products) {
      setState(() {
        allProducts = products;

        displayedProducts =
            allProducts.where((product) => product.stock! > 0).toList();
        selectedCounts = List.generate(displayedProducts.length, (_) => 0);
      });
    });
  }

  Future<List<Productmodel>> getAllProducts() async {
    final addProductBox = await Hive.openBox<Productmodel>('product_db');
    final allProduct = addProductBox.values.toList();
    return List<Productmodel>.from(allProduct);
  }

  void filterProducts(String query) {
    setState(() {
      displayedProducts = allProducts
          .where((product) =>
              product.productname!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openCountDialog(BuildContext context, int index) {
    int count = selectedCounts[index];
    Productmodel product = displayedProducts[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newCount = count;
        return AlertDialog(
          backgroundColor: const Color(0xFFF2E8CD),
          title: const Text('Enter Count'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Available Stock: ${product.stock}'),
              TextFormField(
                initialValue: count.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newCount = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  newCount = newCount.clamp(0, product.stock!);
                  selectedCounts[index] = newCount;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF2E8CD),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // ignore: sized_box_for_whitespace
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  Productmodel product = displayedProducts[index];
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        _openCountDialog(context, index);
                      },
                      child: Text(product.productname!),
                    ),
                    // subtitle: Text('Available: ${product.producount}'),
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
                  const SizedBox(
                    width: 50,
                  ),
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
}
