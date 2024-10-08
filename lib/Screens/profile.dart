import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // For Uint8List
import 'package:hive/hive.dart';
import 'package:upsets/Screens/about.dart';
import 'package:upsets/Screens/privacy_policy.dart';
import 'package:upsets/Screens/sell_product.dart';
import 'package:upsets/Screens/termsofuse.dart';
import 'package:upsets/Screens/login_page.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Userdatamodel> userdataList = [];
  Uint8List? _image;
  Userdatamodel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadImage();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userDataService = UserDataService();
    final retrievedUser = await userDataService.retrieveUserData();

    setState(() {
      user = retrievedUser;
      isLoading = false;
    });
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
        _image = profile.image;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes(); // Read image as bytes
      setState(() {
        _image = bytes;
      });
      await saveData(bytes);
    }
  }

  Future<void> saveData(Uint8List imageData) async {
    final box = await Hive.openBox<ProfileModel>('profile');
    final profile = ProfileModel(image: imageData);
    await box.put('user_profile', profile);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: screenWidth *
                            0.12, // Adjust circle size based on width
                        backgroundImage: _image != null
                            ? MemoryImage(
                                _image!) // Use MemoryImage for Uint8List
                            : const AssetImage('assets/images/profile.jpg')
                                as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: screenWidth * 0.04, // Adjust icon size
                          backgroundColor:
                              const Color.fromARGB(255, 167, 144, 144),
                          child: Icon(
                            Icons.edit,
                            size: screenWidth * 0.06, // Responsive icon size
                            color: const Color.fromARGB(255, 13, 16, 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    width:
                        screenWidth * 0.1), // Adjust width based on screen size
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            size: screenWidth * 0.06, // Responsive icon size
                            color: const Color.fromARGB(255, 42, 39, 39),
                          ),
                          SizedBox(width: screenWidth * 0.02), // Adjust spacing
                          Text(
                            '${user?.name}',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.05, // Responsive text size
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 6, 6, 6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: screenWidth * 0.06,
                            color: const Color.fromARGB(255, 42, 39, 39),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            '${user?.email}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 48, 43, 43),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive height
            Divider(
              color: Colors.white.withOpacity(0.5),
              thickness: 1.0,
            ),
            SizedBox(height: screenHeight * 0.04),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.equalizer,
                      color: Colors.black,
                      size: screenWidth * 0.07, // Responsive icon size
                    ),
                    title: Text(
                      'Sell Product',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045, // Responsive font size
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SellProducts(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.policy_outlined,
                      color: Colors.black,
                      size: screenWidth * 0.07,
                    ),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Privacypolicy(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.handshake_outlined,
                      color: Colors.black,
                      size: screenWidth * 0.07,
                    ),
                    title: Text(
                      'Terms of Use',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsOfUseScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: screenWidth * 0.07,
                    ),
                    title: Text(
                      'About Us',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1), // Adjust button height
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 215, 29, 91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth * 0.3, // Responsive button padding
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    onPressed: () async {
                      final loginBox = await Hive.openBox('loginBox');
                      await loginBox.put('isLoggedIn', false);

                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
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
