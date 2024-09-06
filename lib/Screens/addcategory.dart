import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/Utilities/widgets/textform.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  final TextEditingController _categorycontroller = TextEditingController();
  final GlobalKey<FormState> _ctgrykey = GlobalKey<FormState>();
  File? _image;
  bool _imagePicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          backgroundColor: const Color(0xFFE6B0AA),
          context: context,
          title: 'Add New Category',
          onBackPressed: () {
            Navigator.pop(context);
          }),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6B0AA), // Top shade color
              Color.fromARGB(255, 130, 200, 122), // Bottom shade color
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _ctgrykey,
              child: Column(
                children: [
                  InkWell(
                    onTap: _pickImageFromGallery,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image:
                                    AssetImage("assets/images/addimage.webp"),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  if (!_imagePicked)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select an image',
                        style: TextStyle(
                          color: Color.fromARGB(255, 19, 4, 3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  kheight20,
                  const Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  kheight40,
                  nameInput(
                    name: 'Category',
                    controller: _categorycontroller,
                    label: 'Category',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                    hintText: 'Category',
                  ),
                  kheight70,
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
                        if (_ctgrykey.currentState!.validate()) {
                          if (_image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Please select an image',
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.pop(context, {
                            'name': _categorycontroller.text,
                            'image': _image,
                          });
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 9, 9, 9),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  kheight60,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imagePicked = true;
      });
    } else {
      setState(() {
        _imagePicked = false;
      });
    }
  }
}
