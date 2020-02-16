import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events_scroll_event.dart';
part 'events_scroll_state.dart';

class EventsScrollBloc extends Bloc<EventsScrollEvent, EventsScrollState> {
  @override
  EventsScrollState get initialState => EventsScrollInitial();

  @override
  Stream<EventsScrollState> mapEventToState(
    EventsScrollEvent event,
  ) async* {
    if (event is ScrollPositionChanged) {
      if (event.scrollPosition < 0.5) {
        yield EventsScrollInitial();
      } else {
        if (state is EventsScrollingDown || state is EventsScrollingUp || state is EventsScrollInitial) {
          if (event.scrollPosition > state.scrollPosition) {
            var newOpacity = state.opacity * 0.90;
            if (newOpacity < 0.2) {
              newOpacity = 0;
            }
            yield EventsScrollingDown(scrollPosition: event.scrollPosition, opacity: newOpacity);
          } else if (event.scrollPosition < state.scrollPosition) {
            var oldOpacity = state.opacity;
            if (state.opacity == 0) {
              oldOpacity = 0.1;
            }
            var newOpacity = oldOpacity * 1.5;
            if (newOpacity > 1) {
              newOpacity = 1;
            }
            yield EventsScrollingUp(scrollPosition: event.scrollPosition, opacity: newOpacity);
          } else {
            // When new scroll position = old scroll position. Need to handle this case exclusively because 
            // at the end of a scroll up/down, sometimes a notification will be triggered twice for the 
            // same scroll position. 
            if (state is EventsScrollingUp) {
              yield EventsScrollingUp(scrollPosition: event.scrollPosition, opacity: state.opacity);
            } else if (state is EventsScrollingDown) {
              yield EventsScrollingDown(scrollPosition: event.scrollPosition, opacity: state.opacity);
            } else {
              yield EventsScrollInitial();
            }
          }
        }
      }
    } else if (event is TabSelected) {
      yield EventsScrollInitial();
    } else {
    yield EventsScrollInitial();
    }
  }
}
