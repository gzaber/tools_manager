part of 'search_tools_cubit.dart';

abstract class SearchToolsState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class SearchToolsInitial extends SearchToolsState {}

//==================================================================================================
class SearchToolsLoading extends SearchToolsState {}

//==================================================================================================
class SearchToolsLoadSuccess extends SearchToolsState {
  final List<Tool> tools;

  SearchToolsLoadSuccess(this.tools);

  @override
  List<Object> get props => [tools];
}

//==================================================================================================
class SearchToolsFailure extends SearchToolsState {
  final String message;

  SearchToolsFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================
