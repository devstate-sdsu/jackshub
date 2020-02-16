part of 'filter_tabs_bloc.dart';

abstract class FilterTabsState extends Equatable {
  const FilterTabsState();
}

class FilterTabsInitial extends FilterTabsState {
  @override
  List<Object> get props => [];
}

class FilterTabSelected extends FilterTabsState {
  final int selectedTabIndex;
  const FilterTabSelected({this.selectedTabIndex});
  @override
  List<Object> get props => [this.selectedTabIndex];
}
