import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/tool_model.dart';
import '../../../domain/use_cases/tool_use_cases/search_tools_use_case.dart';

part 'search_tools_state.dart';

class SearchToolsCubit extends Cubit<SearchToolsState> {
  final SearchToolsUseCase _searchToolsUseCase;

  SearchToolsCubit(this._searchToolsUseCase) : super(SearchToolsInitial());

  searchToolsByName(String name) async {
    emit(SearchToolsLoading());
    final result = await _searchToolsUseCase(name);
    if (result.asError != null) {
      emit(SearchToolsFailure(result.asError!.error.toString()));
    } else {
      emit(SearchToolsLoadSuccess(result.asValue!.value));
    }
  }

  clearSearchResults() {
    emit(SearchToolsLoading());
    emit(SearchToolsLoadSuccess(const []));
  }
}
