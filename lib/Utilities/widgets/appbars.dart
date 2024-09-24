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
    required Color iconColor,
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

class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor; // Optional parameter for background color
  final Color? titleColor; // Optional parameter for title text color
  final Color? iconColor; // Optional parameter for icon color
  final VoidCallback
      onNotificationPressed; // Callback for notification button press

  const CustomAppBarHome({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    required this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white, // Default title color
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: iconColor ?? Colors.white, // Default icon color
          ),
          onPressed: onNotificationPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
