import 'package:equatable/equatable.dart';



abstract class SavedEventsEvent extends Equatable {
  const SavedEventsEvent();
}

class GetSavedEventsIds extends SavedEventsEvent {
  const GetSavedEventsIds();
  @override
  List<Object> get props => [];
}

class GetSavedEventsInfo extends SavedEventsEvent {
  const GetSavedEventsInfo();
  @override
  List<Object> get props => [];
}

class AddSavedEvent extends SavedEventsEvent {
  final Map event;
  AddSavedEvent({this.event});
  @override
  List<Object> get props => [this.event['docId']];
}