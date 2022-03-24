import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tools_manager/domain/use_cases/failure_codes.dart';

import '../../../composition_root.dart';
import '../../../data/models/tool_model.dart';
import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/toolbox_cubit/toolbox_cubit.dart';
import '../widgets/dialogs/dialogs.dart';
import '../widgets/widgets.dart';

class ToolboxPage extends StatelessWidget {
  const ToolboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit = BlocProvider.of<CurrentUserCubit>(context);
    ToolboxCubit toolboxCubit = BlocProvider.of<ToolboxCubit>(context);

    toolboxCubit.getTools(currentUserCubit.state.name);

    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: AppLocalizations.of(context)!.titleMyToolbox,
        username: currentUserCubit.state.name,
        leadingIcon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: BlocConsumer<ToolboxCubit, ToolboxState>(
          bloc: toolboxCubit,
          builder: (_, state) {
            if (state is ToolboxLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kOrange,
                ),
              );
            }
            if (state is ToolboxLoadSuccess) {
              return _buildToolList(
                context,
                currentUserCubit.state.name,
                currentUserCubit.state.role,
                state.toolModels,
              );
            }
            if (state is ToolboxLoadFailure) {
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
          listener: (_, state) {
            if (state is ToolboxManageToolFailure) {
              String failureMessage = state.message;
              if (state.message == failureToolnameEmpty) {
                failureMessage = AppLocalizations.of(context)!.failureToolnameEmpty;
              }
              if (state.message == failureToolnameExists) {
                failureMessage = AppLocalizations.of(context)!.failureToolnameExists;
              }

              _showInfoDialog(context, AppLocalizations.of(context)!.titleError, failureMessage);
              toolboxCubit.getTools(currentUserCubit.state.name);
            }
            if (state is ToolboxManageToolSuccess) {
              late String successMessage;
              switch (state.message) {
                case ManageToolSuccessInfo.toolAdded:
                  successMessage = AppLocalizations.of(context)!.infoAddToolSuccess;
                  break;
                case ManageToolSuccessInfo.toolUpdated:
                  successMessage = AppLocalizations.of(context)!.infoUpdateToolSuccess;
                  break;
                case ManageToolSuccessInfo.toolDeleted:
                  successMessage = AppLocalizations.of(context)!.infoDeleteToolSuccess;
                  break;
              }
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(successMessage)));
              Navigator.of(context).pop();
              toolboxCubit.getTools(currentUserCubit.state.name);
            }
          },
        ),
      ),
      floatingActionButton: currentUserCubit.state.role != kRoleUser
          ? CustomFloatingActionButton(onPressed: () {
              _showManageToolDialog(
                context,
                currentUserCubit.state.name,
                AppLocalizations.of(context)!.titleAdd,
                null,
                (ToolModel addedToolModel) {
                  toolboxCubit.addTool(
                      addedToolModel.name, addedToolModel.date, addedToolModel.holder);
                },
              );
            })
          : null,
    );
  }

  ListView _buildToolList(BuildContext context, String currentUsername, String currentUserRole,
      List<ToolModel> toolModels) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: toolModels.length,
      itemBuilder: (_, index) {
        return ToolListItemCard(
          toolModel: toolModels[index],
          username: currentUsername,
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                      builder: (_) =>
                          CompositionRoot.composeToolDetailsPage(toolModels[index].id!)),
                )
                .then(
                  (value) => BlocProvider.of<ToolboxCubit>(context)
                      .getTools(BlocProvider.of<CurrentUserCubit>(context).state.name),
                );
          },
          onLongPressed: currentUserRole != kRoleUser
              ? () {
                  _showPopupMenu(context, currentUsername, toolModels[index]);
                }
              : null,
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, String currentUsername, ToolModel toolModel) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1.0, 88.0, 0.0, 0.0),
      items: [
        PopupMenuItem<String>(
          child: Text(AppLocalizations.of(context)!.titleEdit),
          value: AppLocalizations.of(context)!.titleEdit,
        ),
        PopupMenuItem<String>(
          child: Text(AppLocalizations.of(context)!.titleDelete),
          value: AppLocalizations.of(context)!.titleDelete,
        ),
      ],
    ).then((value) {
      if (value == AppLocalizations.of(context)!.titleEdit) {
        _showManageToolDialog(
          context,
          currentUsername,
          AppLocalizations.of(context)!.titleEdit,
          toolModel,
          (ToolModel updatedToolModel) {
            BlocProvider.of<ToolboxCubit>(context).updateTool(updatedToolModel);
          },
        );
      }
      if (value == AppLocalizations.of(context)!.titleDelete) {
        _showDeleteDialog(
          context,
          AppLocalizations.of(context)!.titleDelete,
          AppLocalizations.of(context)!.descDeleteTool,
          () {
            BlocProvider.of<ToolboxCubit>(context).deleteTool(toolModel.id!);
          },
        );
      }
    });
  }

  _showManageToolDialog(
    BuildContext context,
    String currentUsername,
    String title,
    ToolModel? toolModel,
    Function(ToolModel) onConfirmPressed,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ManageToolDialog(
        currentUsername: currentUsername,
        title: title,
        toolModel: toolModel,
        onConfirmPressed: onConfirmPressed,
      ),
    );
  }

  _showDeleteDialog(
    BuildContext context,
    String title,
    String content,
    Function() onConfirmPressed,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        onConfirmPressed: onConfirmPressed,
      ),
    );
  }

  _showInfoDialog(BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => InfoDialog(title: title, content: content),
    );
  }
}
