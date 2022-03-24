import 'package:flutter/material.dart';

import '../../../domain/entities/tool.dart';
import '../../helpers/helpers.dart';

class ToolListItemCard extends StatelessWidget {
  final Tool tool;
  final String username;
  final Function() onTap;
  final Function()? onLongPressed;

  const ToolListItemCard({
    Key? key,
    required this.tool,
    required this.username,
    required this.onTap,
    required this.onLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: kNavyBlueLight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onLongPressed,
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.build,
                  color: getToolIconColor(tool, username),
                  size: 20.0,
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: Text(
                    tool.name,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
