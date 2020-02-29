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
      if (event.scrollPosition <= 0) {
        yield EventsScrollingUp(scrollPosition: event.scrollPosition, slide: state.slide);
      }
      double difference = ((event.scrollPosition - state.scrollPosition));
      double max = 100;
      double min = 0;
      double newSlide = state.slide + difference;
      if (newSlide >= max) {
        newSlide = max;
      } else if (newSlide <= min) {
        newSlide = min;
      }
      yield EventsScrollingUp(scrollPosition: event.scrollPosition, slide: newSlide);
    } else if (event is TabSelected) {
      yield EventsScrollInitial();
    } else {
    yield EventsScrollInitial();
    }
  }
}
