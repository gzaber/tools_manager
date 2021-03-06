import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/entities/user.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';
import '../custom_text_field.dart';
import '../user_role_radio_list.dart';

class ManageUserDialog extends StatelessWidget {
  final String title;
  final User? user;
  final Function(User) onConfirmPressed;

  const ManageUserDialog({
    Key? key,
    required this.title,
    required this.user,
    required this.onConfirmPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _username = user != null ? user!.name : '';
    String _mobileNumber = user != null
        ? user!.mobileNumber
        : AppLocalizations.of(context)!.countryCode;
    String _role = user != null ? user!.role : kRoleUser;

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              textEditingController: TextEditingController(text: _username),
              textInputType: TextInputType.text,
              hintText: AppLocalizations.of(context)!.hintUsername,
              maxLength: kUsernameMaxLength,
              onChanged: (val) {
                _username = val;
              },
            ),
            const SizedBox(height: 15.0),
            CustomTextField(
              textEditingController: TextEditingController(text: _mobileNumber),
              textInputType: TextInputType.phone,
              hintText: AppLocalizations.of(context)!.hintMobileNumber,
              maxLength: kMobileNumberMaxLength,
              onChanged: (val) {
                _mobileNumber = val;
              },
            ),
            const SizedBox(height: 10.0),
            if (_role != kRoleMaster)
              UserRoleRadioList(
                roles: const [kRoleAdmin, kRoleUser],
                userRole: _role,
                onRadioChanged: (val) {
                  _role = val;
                },
              ),
          ],
        ),
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
            user == null
                ? User(
                    name: _username.trim(),
                    mobileNumber: _mobileNumber.replaceAll(' ', ''),
                    role: _role)
                : User(
                    id: user!.id,
                    name: _username.trim(),
                    mobileNumber: _mobileNumber.replaceAll(' ', ''),
                    role: _role,
                  ),
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
