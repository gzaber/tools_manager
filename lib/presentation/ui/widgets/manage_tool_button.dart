import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

class ManageToolButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const ManageToolButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        color: kNavyBlueLight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 50.0,
                    color: kOrange,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
