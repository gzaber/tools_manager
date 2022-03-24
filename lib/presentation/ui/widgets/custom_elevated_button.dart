import 'package:flutter/material.dart';
import 'package:tools_manager/presentation/helpers/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          primary: kNavyBlueLight,
          textStyle: Theme.of(context).textTheme.button,
        ),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kOrange, fontWeight: FontWeight.bold)),
        onPressed: onPressed,
      ),
    );
  }
}
