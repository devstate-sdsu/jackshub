import 'package:equatable/equatable.dart';

abstract class SavedEventsEvent extends Equatable {
  const SavedEventsEvent();
}

class GetSavedEvents extends SavedEventsEvent {
  const GetSavedEvents();

  @override
  List<Object> get props => [];
}