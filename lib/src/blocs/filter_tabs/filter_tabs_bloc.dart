import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_tabs_event.dart';
part 'filter_tabs_state.dart';

class FilterTabsBloc extends Bloc<FilterTabsEvent, FilterTabsState> {
  @override
  FilterTabsState get initialState => FilterTabsInitial();

  @override
  Stream<FilterTabsState> mapEventToState(
    FilterTabsEvent event,
  ) async* {
    if (event is SelectFilterTab) {
      yield FilterTabSelected(selectedTabIndex: event.tabIndex);
    } else {
      yield FilterTabsInitial();
    }
  }
}
