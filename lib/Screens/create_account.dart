import 'package:flutter/material.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/Screens/login_page.dart';
import 'package:upsets/Utilities/widgets/textform.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController nameInputcontroller = TextEditingController();
  TextEditingController usernameInputcontroller = TextEditingController();
  TextEditingController passwordInputcontroller = TextEditingController();
  TextEditingController emailInputcontroller = TextEditingController();
  TextEditingController mobileInputcontroller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset:
          true, // Change to true to allow scroll when keyboard appears
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/v915-wit-011-f.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                kheight100,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 13, right: 2),
                        child: Column(
                          children: [
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            kheight30,
                            nameInput(
                              hintText: 'Name',
                              label: 'Name',
                              controller: nameInputcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              name: 'Name',
                            ),
                            kheight20,
                            nameInput(
                              name: 'Username',
                              label: 'Username',
                              hintText: 'Username',
                              controller: usernameInputcontroller,
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
                              controller: passwordInputcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            kheight20,
                            nameInput(
                              hintText: 'Email',
                              name: 'Email',
                              label: 'Email',
                              controller: emailInputcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            kheight20,
                            nameInput(
                              hintText: 'Mobile',
                              name: 'Mobile',
                              label: 'Mobile',
                              controller: mobileInputcontroller,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile';
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (ctx) {
                                      return const LoginScreen();
                                    }));
                                  },
                                  child: const Text(
                                    'Login',
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
                                  if (_formKey.currentState!.validate()) {
                                    onCreateAccountButtonClicked();
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
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            kheight100
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onCreateAccountButtonClicked() async {
    final name = nameInputcontroller.text.trim();
    final username = usernameInputcontroller.text.trim();
    final password = passwordInputcontroller.text.trim();
    final email = emailInputcontroller.text.trim();
    final mobile = int.parse(mobileInputcontroller.text.trim());

    if (name.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        mobile.toString().isEmpty) {
      return;
    }

    final user = Userdatamodel(
      name: name,
      username: username,
      password: password,
      email: email,
      mobile: mobile,
    );

    final box = Hive.box<Userdatamodel>('create_account');
    await box.add(user);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        'Account created successfully!',
        style: TextStyle(color: Colors.white),
      ),
    ));

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
      (route) => false,
    );
  }
}
