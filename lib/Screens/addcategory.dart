import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class MyAddnewcatgrs extends StatefulWidget {
  const MyAddnewcatgrs({
    Key? key,
  }) : super(key: key);

  @override
  State<MyAddnewcatgrs> createState() => _MyAddnewcatgrsState();
}

class _MyAddnewcatgrsState extends State<MyAddnewcatgrs> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> ctgryformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Categories",
        backgroundColor: Color(0xFFE6B0AA),
        titleColor: Colors.black,
        onBackPressed: () {
          Navigator.pop(context);
        },
        context: context,
        iconColor: Colors.black,
      ),
      backgroundColor: Colors.white,
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Form(
                key: ctgryformkey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.black,
                                  width: 300,
                                  height: 200,
                                  child: const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 280,
                      height: 80,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a category name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (ctgryformkey.currentState!.validate()) {
                                if (_image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select an image'),
                                    ),
                                  );
                                } else {
                                  _savecategory();
                                  Navigator.pop(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 156, 156),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savecategory() async {
    final categoryName = _nameController.text.trim();
    final image = _image?.path;

    if (categoryName.isEmpty || image == null) {
      return;
    }

    final category = Categorymodel(
      categoryname: categoryName,
      imagepath: image,
    );
    await addCategory(category); // Call the function to add a category
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
}
