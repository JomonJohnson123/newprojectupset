import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:upsets/Screens/sell_product.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/Screens/login_page.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Userdatamodel> userdataList = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> getUserData() async {
    final box = Hive.box<Userdatamodel>('create_account');
    setState(() {
      userdataList = box.values.toList();
    });
  }

  Future<void> loadImage() async {
    final box = await Hive.openBox<ProfileModel>('profile');
    final profile = box.get('user_profile');
    if (profile != null && profile.image.isNotEmpty) {
      setState(() {
        _image = File(profile.image);
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      await saveData();
    }
  }

  Future<void> saveData() async {
    if (_image != null) {
      final box = await Hive.openBox<ProfileModel>('profile');
      final profile = ProfileModel(image: _image!.path);
      await box.put('user_profile', profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 197, 222),
      appBar: AppBar(
        title: const Text(
          'Portfolio',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 161, 197, 222),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : const AssetImage('assets/images/profile.jpg')
                                as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromARGB(255, 167, 144, 144),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Color.fromARGB(255, 13, 16, 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kwidth60,
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'jomonjohnson@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Divider(
              color: Colors.white.withOpacity(0.5),
              thickness: 1.0,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.equalizer,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Sell Product',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SellProducts()));
                    },
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.policy_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: null,
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Terms of Use',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: null,
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Share App',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: null,
                  ),
                  kheight40,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 215, 29, 91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final loginBox = await Hive.openBox('loginBox');
                      await loginBox.put('isLoggedIn', false);

                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
