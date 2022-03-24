import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: kOrange,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
