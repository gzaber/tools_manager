import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../composition_root.dart';
import '../../../domain/entities/user.dart';
import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/home_cubit/home_cubit.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit =
        BlocProvider.of<CurrentUserCubit>(context);
    HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);

    homeCubit.getInfo(currentUserCubit.state.name);

    return Scaffold(
      appBar: CustomAppBar.show(
          context: context,
          title: AppLocalizations.of(context)!.titleToolsManager,
          username: currentUserCubit.state.name,
          leadingIcon: Icons.exit_to_app,
          onPressed: () {
            homeCubit.signOut();
          }),
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          bloc: homeCubit,
          builder: (_, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kOrange,
                ),
              );
            }
            if (state is HomeLoadSuccess) {
              return _buildHomeUI(
                context,
                state.numberOfToolsInStock,
                state.numberOfTransferredTools,
                state.numberOfReceivedTools,
                state.numberOfToolsInToolRoom,
                state.numberOfToolsAtUsers,
                state.numberOfPendingTools,
                state.numberOfRoleMaster,
                state.numberOfRoleAdmin,
                state.numberOfRoleUser,
                currentUserCubit.state,
              );
            }
            if (state is HomeFailure) {
              return Center(
                child: Text(
                  state.message,
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
            if (state is HomeFailure) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
            }
            if (state is HomeSignOutSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => CompositionRoot.composeAuthPage(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView _buildHomeUI(
    BuildContext context,
    int toolsInStock,
    int transferredTools,
    int receivedTools,
    int toolsInToolRoom,
    int toolsAtUsers,
    int pendingTools,
    int numberOfMasters,
    int numberOfAdmins,
    int numberOfUsers,
    User currentUser,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          HomeMenuItemCard(
            title: AppLocalizations.of(context)!.titleMyToolbox,
            icon: Icons.home_repair_service,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => CompositionRoot.composeToolboxPage()))
                  .then(
                    (value) => BlocProvider.of<HomeCubit>(context).getInfo(
                        BlocProvider.of<CurrentUserCubit>(context).state.name),
                  );
            },
            redInfo: (toolsInStock == 0 &&
                    transferredTools == 0 &&
                    receivedTools == 0)
                ? AppLocalizations.of(context)!.zeroTools
                : null,
            greenInfo: toolsInStock == 0
                ? null
                : AppLocalizations.of(context)!.toolsInStock(toolsInStock),
            pinkInfo: transferredTools == 0
                ? null
                : AppLocalizations.of(context)!
                    .transferredTools(transferredTools),
            yellowInfo: receivedTools == 0
                ? null
                : AppLocalizations.of(context)!.receivedTools(receivedTools),
          ),
          HomeMenuItemCard(
            title: AppLocalizations.of(context)!.titleToolRoom,
            icon: Icons.construction,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => CompositionRoot.composeToolRoomPage()))
                  .then(
                    (value) => BlocProvider.of<HomeCubit>(context).getInfo(
                        BlocProvider.of<CurrentUserCubit>(context).state.name),
                  );
            },
            greenInfo:
                AppLocalizations.of(context)!.toolsInToolRoom(toolsInToolRoom),
            redInfo: AppLocalizations.of(context)!.toolsAtUsers(toolsAtUsers),
            yellowInfo:
                AppLocalizations.of(context)!.pendingTools(pendingTools),
          ),
          HomeMenuItemCard(
            title: AppLocalizations.of(context)!.titleUsers,
            icon: Icons.people,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => CompositionRoot.composeUsersPage()))
                  .then(
                    (value) => BlocProvider.of<HomeCubit>(context).getInfo(
                        BlocProvider.of<CurrentUserCubit>(context).state.name),
                  );
            },
            greenInfo: numberOfUsers == 0
                ? AppLocalizations.of(context)!
                    .numberOfAdmins(numberOfMasters + numberOfAdmins)
                : '${AppLocalizations.of(context)!.numberOfAdmins(numberOfMasters + numberOfAdmins)}\n${AppLocalizations.of(context)!.numberOfUsers(numberOfUsers)}',
            redInfo: numberOfUsers == 0
                ? AppLocalizations.of(context)!.numberOfUsers(numberOfUsers)
                : null,
          ),
          HomeMenuItemCard(
            title: AppLocalizations.of(context)!.titleSearch,
            icon: Icons.search,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => CompositionRoot.composeSearchPage()))
                  .then(
                    (value) => BlocProvider.of<HomeCubit>(context).getInfo(
                        BlocProvider.of<CurrentUserCubit>(context).state.name),
                  );
            },
          ),
        ],
      ),
    );
  }
}
