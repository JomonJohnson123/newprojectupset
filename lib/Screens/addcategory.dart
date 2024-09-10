// ignore_for_file: file_names, avoid_unnecessary_containers

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Categories",
        backgroundColor: Colors.white,
        titleColor: Colors.black,
        onBackPressed: () {
          Navigator.pop(context);
        },
        context: context,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
              height: 50,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    hintText: 'Name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      _savecategory();
                    },
                    icon: const Icon(Icons.save),
                    iconSize: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _savecategory() async {
    final name = _nameController.text;
    final image = _image?.path;
    if (image != null && name.isNotEmpty) {
      final category = Categorymodel(imagepath: image, categoryname: name);
      await addCategory(category); // Corrected function call

      setState(() {
        _image = null;
        _nameController.clear();
      });
    }
  }
}
