part of 'events_scroll_bloc.dart';

abstract class EventsScrollEvent extends Equatable {
  const EventsScrollEvent();
}

class ScrollPositionChanged extends EventsScrollEvent {
  final double scrollPosition;
  ScrollPositionChanged(this.scrollPosition);
  @override
  List<Object> get props => [];
}

class TabSelected extends EventsScrollEvent {
  @override
  List<Object> get props => [];
}



