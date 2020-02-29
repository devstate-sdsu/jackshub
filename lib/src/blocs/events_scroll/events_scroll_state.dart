part of 'events_scroll_bloc.dart';

abstract class EventsScrollState extends Equatable {
  final double scrollPosition;
  final double opacity;
  const EventsScrollState() : scrollPosition = 0, opacity = 0;
}

class EventsScrollInitial extends EventsScrollState {
  final double scrollPosition;
  final double opacity;
  EventsScrollInitial() : scrollPosition = 0, opacity = 1;
  @override
  List<Object> get props => [];
}

class EventsScrollingDown extends EventsScrollState {
  final double scrollPosition;
  final double opacity;
  EventsScrollingDown({this.scrollPosition, this.opacity});
  @override
  List<Object> get props => [this.scrollPosition];
}

class EventsScrollingUp extends EventsScrollState {
  final double scrollPosition;
  final double opacity;
  EventsScrollingUp({this.scrollPosition, this.opacity});  
  @override
  List<Object> get props => [this.scrollPosition];
}