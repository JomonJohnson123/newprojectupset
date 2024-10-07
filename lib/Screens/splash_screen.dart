import 'package:flutter/material.dart';
import 'package:upsets/Screens/create_account.dart';
import 'package:hive/hive.dart';
import 'package:upsets/Utilities/widgets/bottom_navbar.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          child: FadeTransition(
            opacity: _animation,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                'assets/images/Screenshot_2024-08-17_135102-removebg-preview.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 4));

    final loginBox = await Hive.openBox('loginBox');
    final isLoggedIn = loginBox.get('isLoggedIn', defaultValue: false);
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return const BottomNavbar();
      }));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return const CreateAccount();
      }));
    }
  }
}
