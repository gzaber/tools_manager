import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tools_manager/domain/use_cases/failure_codes.dart';
import 'package:tools_manager/presentation/ui/widgets/tool_list_item_tool_room.dart';
import '../../../../data/models/tool_model.dart';
import '../../../helpers/helpers.dart';
import '../../../states_management/tool_room_cubit/tool_room_cubit.dart';

class ToolRoomTabView extends StatelessWidget {
  final ToolRoomCubit toolRoomCubit;
  final ToolsViewOption toolsViewOption;

  const ToolRoomTabView({
    Key? key,
    required this.toolRoomCubit,
    required this.toolsViewOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (toolsViewOption) {
      case ToolsViewOption.inToolRoom:
        toolRoomCubit.getInToolRoom();
        break;
      case ToolsViewOption.atUsers:
        toolRoomCubit.getAtUsers();
        break;
      case ToolsViewOption.pending:
        toolRoomCubit.getPending();
        break;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      color: kNavyBlue,
      child: BlocBuilder<ToolRoomCubit, ToolRoomState>(
        bloc: toolRoomCubit,
        builder: (_, state) {
          if (state is ToolRoomLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: kOrange,
              ),
            );
          }
          if (state is ToolRoomLoadSuccess) {
            return _buildToolList(state.toolModels);
          }
          if (state is ToolRoomFailure) {
            String failureMessage = state.message;
            if (state.message == failureNoToolsFound) {
              failureMessage = AppLocalizations.of(context)!.failureNoToolsFound;
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  failureMessage,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildToolList(List<ToolModel> toolModels) {
    return ListView.builder(
      itemCount: toolModels.length,
      itemBuilder: (_, index) {
        return Column(
          children: [
            ToolListItemToolRoom(
              toolModel: toolModels[index],
              toolsViewOption: toolsViewOption,
            ),
            const Divider(height: 2.0),
          ],
        );
      },
    );
  }
}
