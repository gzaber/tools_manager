import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/tool_model.dart';
import '../../helpers/helpers.dart';

class ToolDetailsHeader extends StatelessWidget {
  final ToolModel toolModel;
  final String username;

  const ToolDetailsHeader({
    Key? key,
    required this.toolModel,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavyBlueDark,
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.build,
                color: getToolIconColor(toolModel, username),
                size: 25.0,
              ),
              const SizedBox(width: 10.0),
              Flexible(
                child: Text(
                  toolModel.name,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const Divider(height: 20.0, thickness: 1.0, color: kNavyBlueLight),
          _buildDescriptionRow(context, toolModel, username),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.descDate,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
              ),
              Text(
                toolModel.date,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDescriptionRow(BuildContext context, ToolModel toolModel, String username) {
    ToolStatusByUserOption toolStatusByUserOption = getToolStatusByUser(toolModel, username);
    String desc1 = '';
    String desc2 = '';

    if (toolStatusByUserOption == ToolStatusByUserOption.received) {
      desc1 = AppLocalizations.of(context)!.descReceivedFrom;
      desc2 = toolModel.holder;
    }
    if (toolStatusByUserOption == ToolStatusByUserOption.transferred) {
      desc1 = AppLocalizations.of(context)!.descTransferredTo;
      desc2 = toolModel.receiver!;
    }

    if (toolStatusByUserOption == ToolStatusByUserOption.given) {
      desc1 = AppLocalizations.of(context)!.descGivenFrom;
      desc2 = toolModel.giver!;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          desc1.isEmpty ? AppLocalizations.of(context)!.descAdded : desc1,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
        ),
        Text(
          desc2.isEmpty ? desc2 : desc2,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
