import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/Utilities/widgets/textform.dart';

class SellProduct extends StatefulWidget {
  const SellProduct({super.key});

  @override
  State<SellProduct> createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sellnameController = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  final TextEditingController _prductcontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final TextEditingController _qtycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 151, 228, 221),
      appBar: AppBar(
        title: const Text(
          'Sell Product',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 161, 197, 222),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              kheight50,
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: nameInput(
                  label: 'Name',
                  name: 'Name',
                  hintText: 'Name',
                  controller: _sellnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              kheight20,
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: nameInput(
                    name: 'Mobile',
                    hintText: 'Mobile',
                    controller: _mobilecontroller,
                    label: 'Mobile',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      return null;
                    }),
              ),
              kheight20,
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: nameInput(
                    name: 'Select Product',
                    controller: _prductcontroller,
                    label: ' Select Product',
                    hintText: 'Select Product',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a product';
                      }
                      return null;
                    }),
              ),
              kheight20,
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: nameInput(
                    label: 'Price',
                    hintText: 'Price',
                    name: 'Price',
                    keyboardType: TextInputType.number,
                    controller: _pricecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    }),
              ),
              kheight20,
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: nameInput(
                    keyboardType: TextInputType.number,
                    label: 'Quantity',
                    hintText: 'Quantity',
                    name: 'Quantity',
                    controller: _qtycontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      return null;
                    }),
              ),
              kheight20,
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 37, 93, 134),
                  ),
                  onPressed: () {
                    // Check if the form is valid
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form is valid!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
