import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/tool.dart';
import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/tool_details_cubit/tool_details_cubit.dart';
import '../../states_management/transfer_tool_cubit/transfer_tool_cubit.dart';
import '../widgets/dialogs/dialogs.dart';
import '../widgets/widgets.dart';

class ToolDetailsPage extends StatelessWidget {
  final String toolId;

  const ToolDetailsPage({
    Key? key,
    required this.toolId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit =
        BlocProvider.of<CurrentUserCubit>(context);
    ToolDetailsCubit toolDetailsCubit =
        BlocProvider.of<ToolDetailsCubit>(context);

    toolDetailsCubit.getToolById(toolId);

    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: AppLocalizations.of(context)!.titleToolDetails,
        username: currentUserCubit.state.name,
        leadingIcon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: BlocConsumer<ToolDetailsCubit, ToolDetailsState>(
          bloc: toolDetailsCubit,
          builder: (_, state) {
            if (state is ToolDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kOrange,
                ),
              );
            }
            if (state is ToolDetailsLoadSuccess) {
              return _buildUserDetailsContent(context, toolDetailsCubit,
                  state.tool, currentUserCubit.state.name);
            }
            return const SizedBox();
          },
          listener: (context, state) {
            if (state is ToolDetailsFailure) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                ));
            }
          },
        ),
      ),
    );
  }

  _buildUserDetailsContent(BuildContext context,
      ToolDetailsCubit toolDetailsCubit, Tool tool, String username) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ToolDetailsHeader(tool: tool, username: username),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildButtonRow(context, toolDetailsCubit, tool, username),
          ),
        ],
      ),
    );
  }

  _buildButtonRow(BuildContext context, ToolDetailsCubit toolDetailsCubit,
      Tool tool, String username) {
    ToolStatusByUserOption toolStatusByUserOption =
        getToolStatusByUser(tool, username);

    if (toolStatusByUserOption == ToolStatusByUserOption.added) {
      return Row(
        children: [
          ManageToolButton(
            icon: Icons.sync_alt,
            title: AppLocalizations.of(context)!.titleTransfer,
            onTap: () => _showTransferDialog(
              context,
              username,
              (String receiver) {
                toolDetailsCubit.transfer(tool, receiver);
                Navigator.of(context).pop();
              },
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      );
    }
    if (toolStatusByUserOption == ToolStatusByUserOption.given) {
      return Row(
        children: [
          ManageToolButton(
            icon: Icons.keyboard_return,
            title: AppLocalizations.of(context)!.titleReturn,
            onTap: () => _showConfirmDialog(
              context,
              AppLocalizations.of(context)!.titleReturn,
              AppLocalizations.of(context)!.descReturn,
              () {
                toolDetailsCubit.returnTool(tool);
                Navigator.of(context).pop();
              },
            ),
          ),
          ManageToolButton(
            icon: Icons.sync_alt,
            title: AppLocalizations.of(context)!.titleTransfer,
            onTap: () => _showTransferDialog(
              context,
              username,
              (String receiver) {
                toolDetailsCubit.transfer(tool, receiver);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    }
    if (toolStatusByUserOption == ToolStatusByUserOption.received) {
      return Row(
        children: [
          ManageToolButton(
            icon: Icons.check,
            title: AppLocalizations.of(context)!.titleConfirm,
            onTap: () => _showConfirmDialog(
              context,
              AppLocalizations.of(context)!.titleConfirm,
              AppLocalizations.of(context)!.descConfirm,
              () {
                toolDetailsCubit.confirm(tool);
                Navigator.of(context).pop();
              },
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      );
    }
    if (toolStatusByUserOption == ToolStatusByUserOption.transferred) {
      return Row(
        children: [
          ManageToolButton(
            icon: Icons.cancel_outlined,
            title: AppLocalizations.of(context)!.cancel,
            onTap: () => _showConfirmDialog(
              context,
              AppLocalizations.of(context)!.cancel,
              AppLocalizations.of(context)!.descCancel,
              () {
                toolDetailsCubit.cancel(tool);
                Navigator.of(context).pop();
              },
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      );
    }
  }

  _showConfirmDialog(
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

  _showTransferDialog(
    BuildContext context,
    String username,
    Function(String) onConfirmPressed,
  ) {
    BlocProvider.of<TransferToolCubit>(context).getAllUsers();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocBuilder<TransferToolCubit, TransferToolState>(
        bloc: BlocProvider.of<TransferToolCubit>(context),
        builder: (context, state) {
          if (state is TransferToolLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: kOrange,
              ),
            );
          }
          if (state is TransferToolLoadSuccess) {
            if (state.users.length > 1) {
              return TransferToolDialog(
                currentUsername: username,
                users: state.users,
                onConfirmPressed: onConfirmPressed,
              );
            } else {
              return InfoDialog(
                  title: AppLocalizations.of(context)!.titleInfo,
                  content: AppLocalizations.of(context)!.descNotEnoughUsers);
            }
          }
          if (state is TransferToolFailure) {
            return InfoDialog(
                title: AppLocalizations.of(context)!.titleError,
                content: state.message);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
