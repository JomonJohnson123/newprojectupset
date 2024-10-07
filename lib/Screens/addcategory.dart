import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class MyAddnewcatgrs extends StatefulWidget {
  const MyAddnewcatgrs({Key? key}) : super(key: key);

  @override
  State<MyAddnewcatgrs> createState() => _MyAddnewcatgrsState();
}

class _MyAddnewcatgrsState extends State<MyAddnewcatgrs> {
  Uint8List? _webImage; // For storing image bytes on the web
  XFile? _pickedImage; // For storing picked image
  final TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> ctgryformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Categories",
        backgroundColor: const Color.fromARGB(255, 190, 190, 190),
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
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 112, 113, 111),
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
                          child: _webImage != null
                              ? Image.memory(
                                  _webImage!,
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : _pickedImage != null
                                  ? Image.network(
                                      _pickedImage!.path,
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
                                if (_pickedImage == null && _webImage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select an image'),
                                    ),
                                  );
                                } else {
                                  _saveCategory();
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

  Future<void> _saveCategory() async {
    final categoryName = _nameController.text.trim();
    String? imagePath;

    if (categoryName.isEmpty || (_pickedImage == null && _webImage == null)) {
      return;
    }

    if (_pickedImage != null) {
      imagePath = _pickedImage!.path;
    } else if (_webImage != null) {
      // For web, store image as base64 string
      imagePath = base64Encode(_webImage!);
    }

    final category = Categorymodel(
      categoryname: categoryName,
      imagepath: imagePath!,
    );
    await addCategory(category);
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (kIsWeb) {
        // For web
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        // For mobile/desktop
        setState(() {
          _pickedImage = pickedImage;
        });
      }
    }
  }
}
