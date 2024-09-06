import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/Utilities/widgets/textform.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class AddNewProductsPage extends StatefulWidget {
  const AddNewProductsPage({super.key});

  @override
  State<AddNewProductsPage> createState() => _AddNewProductsPageState();
}

class _AddNewProductsPageState extends State<AddNewProductsPage> {
  final ProductService _productService = ProductService();
  final GlobalKey<FormState> _prdctkey = GlobalKey<FormState>();
  final TextEditingController prdctnamecontroller = TextEditingController();
  final TextEditingController prdctpricecontroller = TextEditingController();
  final TextEditingController prdctquantitycontroller = TextEditingController();
  final TextEditingController discriptioncontroller = TextEditingController();
  File? _image;
  bool _imagePicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            context: context,
            backgroundColor: const Color(0xFFE6B0AA),
            title: 'Add New Products',
            onBackPressed: () {
              Navigator.pop(context);
            }),
        body: Container(
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
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Form(
                  key: _prdctkey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: pickPrdctImage,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: _imagePicked
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/addimage.webp'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      if (!_imagePicked)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Please select an image',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 20, 19, 19),
                                  fontSize: 12.0)),
                        ),
                      kheight20,
                      const Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      kheight20,
                      nameInput(
                        name: 'Product Name',
                        controller: prdctnamecontroller,
                        label: 'Product Name',
                        validator: (context) {
                          if (prdctnamecontroller.text.isEmpty) {
                            return 'Please enter a product name';
                          }
                          return null;
                        },
                        hintText: 'Product Name',
                      ),
                      kheight20,
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: qtyinput(
                                name: 'Quantity',
                                controller: prdctquantitycontroller,
                                label: 'Quantity',
                                validator: (value) {
                                  if (prdctquantitycontroller.text.isEmpty) {
                                    return 'Please enter a quantity';
                                  } else if (int.tryParse(value!) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                                hintText: "Quantity",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: priceinput(
                                name: 'Price',
                                controller: prdctpricecontroller,
                                label: 'Price',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a price';
                                  } else if (double.tryParse(value) == null) {
                                    return 'Please enter a valid price';
                                  }
                                  return null;
                                },
                                hintText: 'Price',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            kheight20,
                          ]),
                      kheight20,
                      descriptionField(
                        name: 'Description',
                        controller: discriptioncontroller,
                        label: 'Enter Description',
                        hintText: 'Enter description ',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      kheight20,
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 249, 162, 162),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              // Check if the form fields are validated
                              if (_prdctkey.currentState!.validate()) {
                                // Check if an image is selected
                                if (_image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Please select an image'),
                                    ),
                                  );
                                  return;
                                }

                                _saveProduct();
                              }
                            },
                            child: const Text('Submit',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 39, 37, 37),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      kheight60,
                    ],
                  ),
                ),
              )),
        ));
  }

  Future<void> _saveProduct() async {
    ProductModel newProduct = ProductModel(
      productname: prdctnamecontroller.text,
      productimage: _image!.path,
      productQuantity: prdctquantitycontroller.text,
      productPrice: prdctpricecontroller.text,
      productDescription: discriptioncontroller.text,
    );

    await _productService.addProduct(newProduct);
    Navigator.pop(context); // Return to the product list page after saving.
  }

  Future<void> pickPrdctImage() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        _image = File(pickedimage.path);
        _imagePicked = true;
      });
    } else {
      setState(() {
        _imagePicked = false;
      });
    }
  }
}
