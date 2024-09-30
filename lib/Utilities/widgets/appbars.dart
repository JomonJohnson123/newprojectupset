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
  final int badgeCount; // Count of new notifications
  final VoidCallback
      onNotificationPressed; // Callback for notification button press

  const CustomAppBarHome({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    required this.badgeCount,
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
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: iconColor ?? Colors.white, // Default icon color
              ),
              onPressed: onNotificationPressed,
            ),
            if (badgeCount > 0) // Show badge only when there is a count
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red, // Badge color
                    borderRadius: BorderRadius.circular(12), // Circular shape
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 22,
                    minHeight: 24,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount', // Display notification count
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarSellPage extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor; // Optional parameter for background color
  final Color? titleColor; // Optional parameter for title text color
  final Color? iconColor; // Optional parameter for icon color
  final VoidCallback
      onNotificationPressed; // Callback for notification button press

  const CustomAppBarSellPage({
    super.key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    required this.onNotificationPressed,
    required BuildContext context,
    required List<IconButton> actions,
  });

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
            Icons.calendar_today,
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
