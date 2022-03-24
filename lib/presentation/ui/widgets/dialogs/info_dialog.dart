import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/colors.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  const InfoDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
