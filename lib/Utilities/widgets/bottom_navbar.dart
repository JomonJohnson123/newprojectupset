import 'package:flutter/material.dart';
import 'package:upsets/Screens/category.dart';
import 'package:upsets/Screens/explore.dart';
import 'package:upsets/Screens/profile.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentSelectedIndex = 0;
  final List<Widget> _pages = [
    const ExplorePage(),
    const CategoryPage(),
    const ProfilePage(),
  ];

  BottomNavigationBarItem _bottomNavItem(
      {required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentSelectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 33, 29, 29),
        backgroundColor: Color.fromARGB(246, 232, 232, 227),
        currentIndex: _currentSelectedIndex,
        onTap: _onItemTapped,
        items: [
          _bottomNavItem(icon: Icons.home, label: 'Home'),
          _bottomNavItem(icon: Icons.storefront, label: 'Category'),
          _bottomNavItem(icon: Icons.person, label: 'Profile'),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
