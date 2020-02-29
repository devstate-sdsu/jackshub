part of 'events_scroll_bloc.dart';

abstract class EventsScrollState extends Equatable {
  final double scrollPosition;
  final double slide;
  const EventsScrollState() : scrollPosition = 0, slide = 10;
}

class EventsScrollInitial extends EventsScrollState {
  final double scrollPosition;
  final double slide;
  EventsScrollInitial() : scrollPosition = 0, slide = 10;
  @override
  List<Object> get props => [];
}

class EventsScrollingDown extends EventsScrollState {
  final double scrollPosition;
  final double slide;
  EventsScrollingDown({this.scrollPosition, this.slide});
  @override
  List<Object> get props => [this.scrollPosition];
}

class EventsScrollingUp extends EventsScrollState {
  final double scrollPosition;
  final double slide;
  EventsScrollingUp({this.scrollPosition, this.slide});  
  @override
  List<Object> get props => [this.scrollPosition];
}