import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final Color? backgroundColor; // Optional parameter for background color
  final Color? titleColor; // Optional parameter for title text color
  // Optional parameter for icon color

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    required BuildContext context,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
        ),
        onPressed: onBackPressed,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: titleColor ??
                const Color.fromARGB(
                    255, 18, 16, 16)), // Use the title color if provided
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ??
          Theme.of(context)
              .primaryColor, // Use the background color if provided
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
