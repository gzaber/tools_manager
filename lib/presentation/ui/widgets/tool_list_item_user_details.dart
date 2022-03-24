import 'package:flutter/material.dart';

import '../../../domain/entities/tool.dart';
import '../../helpers/helpers.dart';

class ToolListItemUserDetails extends StatelessWidget {
  final Tool tool;
  final String username;

  const ToolListItemUserDetails({
    Key? key,
    required this.tool,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavyBlueDark,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
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
              const SizedBox(width: 10.0),
              if (getToolStatusByUser(tool, username) ==
                      ToolStatusByUserOption.received ||
                  getToolStatusByUser(tool, username) ==
                      ToolStatusByUserOption.transferred)
                Text(
                  getToolStatusByUser(tool, username) ==
                          ToolStatusByUserOption.received
                      ? '${tool.holder} ->'
                      : '-> ${tool.receiver}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: getToolIconColor(tool, username),
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
