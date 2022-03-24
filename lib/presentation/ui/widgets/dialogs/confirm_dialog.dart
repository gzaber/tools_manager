import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onConfirmPressed;
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirmPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kOrange, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: onConfirmPressed,
          child: Text(
            AppLocalizations.of(context)!.ok,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kOrange, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
