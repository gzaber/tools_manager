import 'package:flutter/material.dart';
import 'package:tools_manager/data/models/tool_model.dart';
import 'package:tools_manager/presentation/helpers/constants.dart';
import 'package:tools_manager/presentation/helpers/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/colors.dart';

class ManageToolDialog extends StatelessWidget {
  final String currentUsername;
  final String title;
  final ToolModel? toolModel;
  final Function(ToolModel) onConfirmPressed;

  const ManageToolDialog({
    Key? key,
    required this.currentUsername,
    required this.title,
    required this.toolModel,
    required this.onConfirmPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _toolName = toolModel != null ? toolModel!.name : '';

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: TextEditingController(text: _toolName),
        cursorColor: kNavyBlue,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          helperText: AppLocalizations.of(context)!.hintToolname,
          helperStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
          hintText: AppLocalizations.of(context)!.hintToolname,
          hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: kNavyBlue),
          counterStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
        ),
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: kNavyBlue,
            ),
        maxLines: kToolMaxLines,
        maxLength: kToolMaxLength,
        onChanged: (text) {
          _toolName = text;
        },
      ),
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
          onPressed: () => onConfirmPressed(
            toolModel == null
                ? ToolModel(name: _toolName.trim(), date: getCurrentDate(), holder: currentUsername)
                : ToolModel(
                    id: toolModel!.id,
                    name: _toolName.trim(),
                    date: toolModel!.date,
                    giver: toolModel!.giver,
                    holder: toolModel!.holder,
                    receiver: toolModel!.receiver),
          ),
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
