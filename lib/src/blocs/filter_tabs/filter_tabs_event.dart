part of 'filter_tabs_bloc.dart';

abstract class FilterTabsEvent extends Equatable {
  const FilterTabsEvent();
}

class SelectFilterTab extends FilterTabsEvent {
  final int tabIndex;
  const SelectFilterTab({this.tabIndex});
  List<Object> get props => [tabIndex];
}