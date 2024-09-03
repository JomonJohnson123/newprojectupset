import 'package:flutter/material.dart';
import 'package:upsets/Screens/create_account.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/Utilities/widgets/textform.dart';
import 'package:upsets/Utilities/widgets/bottom_navbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../db/functions/hiveModel/model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/v915-wit-011-f.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 106,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 13,
                      right: 3,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        kheight50,
                        nameInput(
                          hintText: 'Username',
                          name: "Username",
                          label: 'Username',
                          controller: _userNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        kheight20,
                        nameInput(
                          hintText: 'Password',
                          name: 'Password',
                          label: 'Password',
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return const CreateAccount();
                                }));
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_globalKey.currentState!.validate()) {
                                checkLogin();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Please enter all fields',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 30, 66, 98),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkLogin() async {
    final userBox = Hive.box<Userdatamodel>('create_account');
    final users = userBox.values;

    final username = _userNameController.text;
    final password = _passwordController.text;

    bool foundUser = false;
    for (var user in users) {
      if (user.username == username && user.password == password) {
        foundUser = true;

        // Store the login status
        final loginBox = await Hive.openBox('loginBox');
        await loginBox.put('isLoggedIn', true);

        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
          (route) => false,
        );
        break;
      }
    }

    if (!foundUser) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Please enter correct username and password',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}
