import 'package:flutter/material.dart';

import '../../../data/models/tool_model.dart';
import '../../helpers/helpers.dart';

class ToolListItemUserDetails extends StatelessWidget {
  final ToolModel toolModel;
  final String username;

  const ToolListItemUserDetails({
    Key? key,
    required this.toolModel,
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
                      color: getToolIconColor(toolModel, username),
                      size: 20.0,
                    ),
                    const SizedBox(width: 16.0),
                    Flexible(
                      child: Text(
                        toolModel.name,
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
              if (getToolStatusByUser(toolModel, username) == ToolStatusByUserOption.received ||
                  getToolStatusByUser(toolModel, username) == ToolStatusByUserOption.transferred)
                Text(
                  getToolStatusByUser(toolModel, username) == ToolStatusByUserOption.received
                      ? '${toolModel.holder} ->'
                      : '-> ${toolModel.receiver}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: getToolIconColor(toolModel, username),
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
