import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tools_manager/domain/use_cases/failure_codes.dart';

import '../../../domain/entities/tool.dart';
import '../../helpers/helpers.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../../states_management/search_tools_cubit/search_tools_cubit.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class SearchToolsPage extends StatelessWidget {
  const SearchToolsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUserCubit currentUserCubit =
        BlocProvider.of<CurrentUserCubit>(context);
    SearchToolsCubit searchToolsCubit =
        BlocProvider.of<SearchToolsCubit>(context);

    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: AppLocalizations.of(context)!.titleSearch,
        username: currentUserCubit.state.name,
        leadingIcon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              color: kNavyBlue,
              child: CustomTextField(
                hintText: AppLocalizations.of(context)!.hintSearchForTools,
                textEditingController: TextEditingController(text: null),
                textInputType: TextInputType.name,
                maxLength: kSearchToolMaxLength,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    searchToolsCubit.searchToolsByName(val);
                  } else {
                    searchToolsCubit.clearSearchResults();
                  }
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchToolsCubit, SearchToolsState>(
                bloc: searchToolsCubit,
                builder: (_, state) {
                  if (state is SearchToolsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kOrange,
                      ),
                    );
                  }
                  if (state is SearchToolsLoadSuccess) {
                    return _buildToolList(context, state.tools);
                  }
                  if (state is SearchToolsFailure) {
                    String failureMessage = state.message;
                    if (state.message == failureNoToolsFound) {
                      failureMessage =
                          AppLocalizations.of(context)!.failureNoToolsFound;
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolList(BuildContext context, List<Tool> tools) {
    return ListView.builder(
      shrinkWrap: false,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: tools.length,
      itemBuilder: (_, index) => Column(
        children: [
          ListTile(
            tileColor: kNavyBlueDark,
            textColor: Colors.white,
            leading: const Icon(
              Icons.build_circle,
              size: 25.0,
              color: kOrange,
            ),
            title: Text(tools[index].name),
            trailing: Text(tools[index].holder),
          ),
          const Divider(height: 2.0),
        ],
      ),
    );
  }
}
