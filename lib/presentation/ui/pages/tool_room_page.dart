import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/tool_room_cubit/tool_room_cubit.dart';
import '../widgets/widgets.dart';
import 'tab_views/tool_room_tab_view.dart';

class ToolRoomPage extends StatelessWidget {
  const ToolRoomPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit = BlocProvider.of<CurrentUserCubit>(context);
    ToolRoomCubit toolRoomCubit = BlocProvider.of<ToolRoomCubit>(context);

    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: AppLocalizations.of(context)!.titleToolRoom,
        username: currentUserCubit.state.name,
        leadingIcon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: ToolRoomTabBar(
        titles: [
          Text(
            AppLocalizations.of(context)!.tabAvailable,
            style: const TextStyle(color: kGreen),
          ),
          Text(
            AppLocalizations.of(context)!.tabAtUsers,
            style: const TextStyle(color: kRed),
          ),
          Text(
            AppLocalizations.of(context)!.tabPending,
            style: const TextStyle(color: kYellow),
          ),
        ],
        tabViews: [
          ToolRoomTabView(
            toolRoomCubit: toolRoomCubit,
            toolsViewOption: ToolsViewOption.inToolRoom,
          ),
          ToolRoomTabView(
            toolRoomCubit: toolRoomCubit,
            toolsViewOption: ToolsViewOption.atUsers,
          ),
          ToolRoomTabView(
            toolRoomCubit: toolRoomCubit,
            toolsViewOption: ToolsViewOption.pending,
          ),
        ],
      ),
    );
  }
}
