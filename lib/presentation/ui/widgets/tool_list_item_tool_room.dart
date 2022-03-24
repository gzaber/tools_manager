import 'package:flutter/material.dart';

import '../../../domain/entities/tool.dart';
import '../../helpers/helpers.dart';

class ToolListItemToolRoom extends StatelessWidget {
  final Tool tool;
  final ToolsViewOption toolsViewOption;

  const ToolListItemToolRoom({
    Key? key,
    required this.tool,
    required this.toolsViewOption,
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
                      color: (toolsViewOption == ToolsViewOption.inToolRoom)
                          ? kGreen
                          : (toolsViewOption == ToolsViewOption.atUsers)
                              ? kRed
                              : kYellow,
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
              if (toolsViewOption == ToolsViewOption.inToolRoom)
                Text(
                  '<- ${tool.holder}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: kGreen),
                ),
              if (toolsViewOption == ToolsViewOption.atUsers)
                Text(
                  '-> ${tool.holder}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: kRed),
                ),
              if (toolsViewOption == ToolsViewOption.pending)
                Text(
                  '${tool.holder} -> ${tool.receiver}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: kYellow),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
