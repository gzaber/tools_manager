import 'package:flutter/material.dart';

import '../../../data/models/tool_model.dart';
import '../../helpers/helpers.dart';

class ToolListItemToolRoom extends StatelessWidget {
  final ToolModel toolModel;
  final ToolsViewOption toolsViewOption;

  const ToolListItemToolRoom({
    Key? key,
    required this.toolModel,
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
              if (toolsViewOption == ToolsViewOption.inToolRoom)
                Text(
                  '<- ${toolModel.holder}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kGreen),
                ),
              if (toolsViewOption == ToolsViewOption.atUsers)
                Text(
                  '-> ${toolModel.holder}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kRed),
                ),
              if (toolsViewOption == ToolsViewOption.pending)
                Text(
                  '${toolModel.holder} -> ${toolModel.receiver}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: kYellow),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
