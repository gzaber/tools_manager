import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tools_manager/domain/use_cases/failure_codes.dart';

import '../../../composition_root.dart';
import '../../../domain/entities/user.dart';
import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/users_cubit/users_cubit.dart';
import '../widgets/dialogs/dialogs.dart';
import '../widgets/widgets.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit =
        BlocProvider.of<CurrentUserCubit>(context);
    UsersCubit usersCubit = BlocProvider.of<UsersCubit>(context);
    usersCubit.getInfo();

    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: AppLocalizations.of(context)!.titleUsers,
        username: currentUserCubit.state.name,
        leadingIcon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: BlocConsumer<UsersCubit, UsersState>(
          bloc: usersCubit,
          builder: (_, state) {
            if (state is UsersLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kOrange,
                ),
              );
            }
            if (state is UsersLoadSuccess) {
              return _buildUsersList(
                _,
                currentUserCubit.state,
                state.users,
                state.toolsInStockCounters,
                state.transferredToolsCounters,
                state.receivedToolsCounters,
              );
            }
            if (state is UsersFailure) {
              String failureMessage = state.message;
              if (state.message == failureNoUsersFound) {
                failureMessage =
                    AppLocalizations.of(context)!.failureNoUsersFound;
              }
              return Center(
                child: Text(
                  failureMessage,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
              );
            }
            return const SizedBox();
          },
          listener: (_, state) {
            if (state is UsersManageUserFailure) {
              String failureMessage = state.message;
              if (state.message == failureUsernameEmpty) {
                failureMessage =
                    AppLocalizations.of(context)!.failureUsernameEmpty;
              }
              if (state.message == failureMobileNumberEmpty) {
                failureMessage =
                    AppLocalizations.of(context)!.failureMobileNumberEmpty;
              }
              if (state.message == failureUsernameExists) {
                failureMessage =
                    AppLocalizations.of(context)!.failureUsernameExists;
              }
              if (state.message == failureMobileNumberExists) {
                failureMessage =
                    AppLocalizations.of(context)!.failureMobileNumberExists;
              }
              _showInfoDialog(context, AppLocalizations.of(context)!.titleError,
                  failureMessage);
              usersCubit.getInfo();
            }
            if (state is UsersManageUserSuccess) {
              late String successMessage;
              switch (state.message) {
                case ManageUserSuccessInfo.userAdded:
                  successMessage =
                      AppLocalizations.of(context)!.infoAddUserSuccess;
                  break;
                case ManageUserSuccessInfo.userUpdated:
                  successMessage =
                      AppLocalizations.of(context)!.infoUpdateUserSuccess;
                  break;
                case ManageUserSuccessInfo.userDeleted:
                  successMessage =
                      AppLocalizations.of(context)!.infoDeleteUserSuccess;
                  break;
              }
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(successMessage)));
              Navigator.of(context).pop();
              usersCubit.getInfo();
            }
          },
        ),
      ),
      floatingActionButton: currentUserCubit.state.role == kRoleMaster
          ? CustomFloatingActionButton(onPressed: () {
              _showManageUserDialog(
                context,
                AppLocalizations.of(context)!.titleAdd,
                null,
                (User addedUser) {
                  usersCubit.addUser(
                      addedUser.name, addedUser.mobileNumber, addedUser.role);
                },
              );
            })
          : null,
    );
  }

  ListView _buildUsersList(
      BuildContext context,
      User currentUser,
      List<User> users,
      List<int> toolsInStockCounters,
      List<int> transferredToolsCounters,
      List<int> receivedToolsCounters) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: users.length,
      itemBuilder: (_, index) {
        return UserListItemCard(
          user: users[index],
          numberOfToolsInStock: toolsInStockCounters[index],
          numberOfTransferredTools: transferredToolsCounters[index],
          numberOfReceivedTools: receivedToolsCounters[index],
          onTap: () {
            Navigator.of(_)
                .push(
                  MaterialPageRoute(
                    builder: (_) => CompositionRoot.composeUserDetailsPage(
                      users[index],
                      toolsInStockCounters[index],
                      transferredToolsCounters[index],
                      receivedToolsCounters[index],
                    ),
                  ),
                )
                .then(
                    (value) => BlocProvider.of<UsersCubit>(context).getInfo());
          },
          onLongPressed: currentUser.role == kRoleMaster
              ? () {
                  _showPopupMenu(context, currentUser.name, users[index]);
                }
              : null,
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, String currentUsername, User user) {
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
        _showManageUserDialog(
          context,
          AppLocalizations.of(context)!.titleEdit,
          user,
          (User updatedUser) {
            BlocProvider.of<UsersCubit>(context).updateUser(updatedUser);
            if (updatedUser.role == kRoleMaster) {
              BlocProvider.of<CurrentUserCubit>(context).update(
                User(
                  id: updatedUser.id,
                  name: updatedUser.name,
                  mobileNumber: updatedUser.mobileNumber,
                  role: updatedUser.role,
                ),
              );
            }
          },
        );
      }
      if (value == AppLocalizations.of(context)!.titleDelete) {
        if (currentUsername != user.name) {
          _showDeleteDialog(
            context,
            AppLocalizations.of(context)!.titleDelete,
            AppLocalizations.of(context)!.descDeleteUser,
            () {
              BlocProvider.of<UsersCubit>(context).deleteUser(
                user.id!,
                BlocProvider.of<CurrentUserCubit>(context).state.name,
              );
            },
          );
        } else {
          _showInfoDialog(context, AppLocalizations.of(context)!.titleInfo,
              AppLocalizations.of(context)!.descDeleteYourself);
        }
      }
    });
  }

  _showManageUserDialog(
    BuildContext context,
    String title,
    User? user,
    Function(User) onConfirmPressed,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ManageUserDialog(
        title: title,
        user: user,
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
