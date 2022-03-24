import 'package:flutter/material.dart';

class UserRoleRadioList extends StatefulWidget {
  final List<String> roles;
  final String userRole;
  final Function(String) onRadioChanged;

  const UserRoleRadioList({
    Key? key,
    required this.roles,
    required this.userRole,
    required this.onRadioChanged,
  }) : super(key: key);

  @override
  State<UserRoleRadioList> createState() => _UserRoleRadioListState();
}

class _UserRoleRadioListState extends State<UserRoleRadioList> {
  String? _selectedRole;

  @override
  void initState() {
    _selectedRole = widget.userRole;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      child: Column(
        children: List.generate(widget.roles.length, (index) {
          return RadioListTile<String>(
            activeColor: Colors.white,
            title: Text(
              widget.roles[index],
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            value: widget.roles[index],
            groupValue: _selectedRole,
            onChanged: (value) {
              widget.onRadioChanged(value!);
              setState(() {
                _selectedRole = value;
              });
            },
          );
        }),
      ),
    );
  }
}
