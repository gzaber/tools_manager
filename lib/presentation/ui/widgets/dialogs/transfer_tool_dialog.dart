import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/entities/user.dart';
import '../../../helpers/colors.dart';

class TransferToolDialog extends StatefulWidget {
  final String currentUsername;
  final List<User> users;
  final Function(String receiver) onConfirmPressed;

  const TransferToolDialog({
    Key? key,
    required this.currentUsername,
    required this.users,
    required this.onConfirmPressed,
  }) : super(key: key);

  @override
  _TransferToolDialogState createState() => _TransferToolDialogState();
}

class _TransferToolDialogState extends State<TransferToolDialog> {
  late List<String> _usernames;
  late List<String> _availableUsers;
  late String _dropdownValue;

  @override
  void initState() {
    _usernames = widget.users.map((user) => user.name).toList();
    _availableUsers = _usernames
        .where((element) => element != widget.currentUsername)
        .toList();
    _dropdownValue = _availableUsers[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(AppLocalizations.of(context)!.titleTransfer),
        content: DropdownButton<String>(
          value: _dropdownValue,
          dropdownColor: kOrange,
          iconEnabledColor: kOrange,
          isExpanded: true,
          underline: Container(height: 2.0, color: kOrange),
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Colors.white,
              ),
          items: _availableUsers
              .map((username) => DropdownMenuItem(
                    value: username,
                    child: Text(username),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              _dropdownValue = newValue!;
            });
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
            onPressed: () => widget.onConfirmPressed(_dropdownValue),
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: kOrange, fontWeight: FontWeight.bold),
            ),
          ),
        ]);
  }
}
