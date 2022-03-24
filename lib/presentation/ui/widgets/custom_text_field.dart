import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? textEditingController;
  final TextInputType textInputType;
  final int maxLength;
  final Function(String) onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    required this.textInputType,
    required this.maxLength,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      cursorColor: kNavyBlue,
      decoration: InputDecoration(
        helperText: hintText,
        helperStyle: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.white,
            ),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: kNavyBlue),
        counterStyle: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.white,
            ),
      ),
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: kNavyBlue,
          ),
      maxLength: maxLength,
      onChanged: onChanged,
    );
  }
}
