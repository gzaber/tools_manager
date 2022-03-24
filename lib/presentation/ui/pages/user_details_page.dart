import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/tool_model.dart';
import '../../../data/models/user_model.dart';
import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/user_details_cubit/user_details_cubit.dart';
import '../widgets/widgets.dart';

class UserDetailsPage extends StatelessWidget {
  final UserModel userModel;
  final int numberOfToolsInStock;
  final int numberOfTransferredTools;
  final int numberOfReceivedTools;

  const UserDetailsPage({
    Key? key,
    required this.userModel,
    required this.numberOfToolsInStock,
    required this.numberOfTransferredTools,
    required this.numberOfReceivedTools,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit =
        BlocProvider.of<CurrentUserCubit>(context);
    UserDetailsCubit userDetailsCubit =
        BlocProvider.of<UserDetailsCubit>(context);
    userDetailsCubit.getUserTools(userModel.name);

    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: AppLocalizations.of(context)!.titleUserDetails,
        username: currentUserCubit.state.name,
        leadingIcon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserDetailsHeader(
                userModel: userModel,
                numberOfToolsInStock: numberOfToolsInStock,
                numberOfTransferredTools: numberOfTransferredTools,
                numberOfReceivedTools: numberOfReceivedTools,
              ),
              BlocBuilder<UserDetailsCubit, UserDetailsState>(
                bloc: userDetailsCubit,
                builder: (_, state) {
                  if (state is UserDetailsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kOrange,
                      ),
                    );
                  }
                  if (state is UserDetailsLoadSuccess) {
                    return _buildUserDetails(
                        context, state.toolModels, userModel.name);
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(
      BuildContext context, List<ToolModel> toolModels, String username) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: List.generate(
          toolModels.length,
          (index) => Column(
            children: [
              ToolListItemUserDetails(
                toolModel: toolModels[index],
                username: username,
              ),
              const Divider(height: 2.0),
            ],
          ),
        ),
      ),
    );
  }
}
