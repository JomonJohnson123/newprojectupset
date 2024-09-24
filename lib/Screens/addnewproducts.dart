// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/Utilities/widgets/textform.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class Addproduct extends StatefulWidget {
  final String categoryname;

  const Addproduct({Key? key, required this.categoryname}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class Allproduct {
  static List<Productmodel> product = [];
}

class _AddproductState extends State<Addproduct> {
  String? selectedCategory;
  File? _imagee;

  final TextEditingController productnamecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController sellingratecontroller = TextEditingController();
  final TextEditingController purchaseratecontroller = TextEditingController();
  final TextEditingController stockconteroller = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    getallproduct();

    _categories = [];
    _categories.add(widget.categoryname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Product",
        backgroundColor: const Color(0xFFE6B0AA),
        titleColor: Colors.black,
        onBackPressed: () {
          Navigator.pop(context);
        },
        context: context,
        iconColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFE6B0AA),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6B0AA),
              Color.fromARGB(255, 130, 200, 122),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          pickimage();
                        },
                        child: Container(
                          child: _imagee != null
                              ? Image.file(
                                  _imagee!,
                                  width: 300,
                                  height: 170,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.black,
                                  width: 300,
                                  height: 170,
                                  child: const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BuildTextFormField1(
                    controller: productnamecontroller,
                    labelText: 'Product name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    width: 340,
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: _categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Category name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BuildTextFormField1(
                    controller: descriptioncontroller,
                    labelText: 'Description',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BuildTextFormField2(
                    controller: sellingratecontroller,
                    labelText: 'Selling rate',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter selling rate';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BuildTextFormField2(
                    controller: purchaseratecontroller,
                    labelText: 'Purchase rate',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' Please enter purchase rate';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BuildTextFormField2(
                    controller: stockconteroller,
                    labelText: 'Stock quantity',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' Please enter stock quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          if (_imagee != null) {
                            onsave();

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Please select an image'),
                              ),
                            );
                          }
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(239, 241, 133, 123)),
                      ),
                      child: const Text(
                        'Save',
                        style:
                            TextStyle(color: Color.fromARGB(255, 40, 35, 35)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickimage() async {
    // ignore: non_constant_identifier_names
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile == null) return;

    print('"Image path: ${PickedFile.path}"');
    setState(() {
      _imagee = File(PickedFile.path);
    });
  }

  //save the added products
  Future<void> onsave() async {
    final productName = productnamecontroller.text.trim();
    final category = widget.categoryname;
    final description = descriptioncontroller.text.trim();
    final sellingRate = sellingratecontroller.text.trim();
    final purchaseRate = purchaseratecontroller.text.trim();
    final stockquantity = stockconteroller.text.trim();

    if (productName.isEmpty ||
        category.isEmpty ||
        description.isEmpty ||
        sellingRate.isEmpty ||
        purchaseRate.isEmpty ||
        productName.isEmpty ||
        stockquantity.isEmpty) {
      return;
    }

    final data = Productmodel(
      image: _imagee?.path ?? '',
      productname: productName,
      categoryname: category,
      description: description,
      sellingrate: int.parse(sellingRate),
      purchaserate: int.parse(purchaseRate),
      stock: int.parse(stockquantity),
    );

    await addproducts(data, category);
    print('Product added successfully: $data');
    setState(() {
      _imagee = null;
      productnamecontroller.clear();
      descriptioncontroller.clear();
      sellingratecontroller.clear();
      purchaseratecontroller.clear();
      stockconteroller.clear();
    });
  }
}
