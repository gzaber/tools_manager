import 'package:flutter/material.dart';

class CustomAppBar {
  static show({
    required BuildContext context,
    required String title,
    required String username,
    required IconData leadingIcon,
    required Function() onPressed,
  }) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(leadingIcon),
        onPressed: onPressed,
      ),
      actions: [
        Row(
          children: [
            const Icon(Icons.account_circle),
            const SizedBox(
              width: 8.0,
            ),
            Text(username),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
      ],
    );
  }
}
