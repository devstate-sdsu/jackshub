import 'package:equatable/equatable.dart';
import 'package:jackshub/util/database_helpers.dart';



abstract class SavedEventsEvent extends Equatable {
  const SavedEventsEvent();
}

class GetSavedEventsInfo extends SavedEventsEvent {
  const GetSavedEventsInfo();
  @override
  List<Object> get props => [];
}

class AddSavedEvent extends SavedEventsEvent {
  final EventInfo eventInfo;
  AddSavedEvent({this.eventInfo});
  @override
  List<Object> get props => [this.eventInfo.documentId];
}

class DeleteSavedEvent extends SavedEventsEvent {
  final String documentId;
  DeleteSavedEvent({this.documentId});
  @override
  List<Object> get props => [this.documentId];
}

class AddSavedEventWithoutRefresh extends SavedEventsEvent {
  final EventInfo eventInfo;
  AddSavedEventWithoutRefresh({this.eventInfo});
  @override
  List<Object> get props => [this.eventInfo.documentId];
}

class DeleteSavedEventWithoutRefresh extends SavedEventsEvent {
  final String documentId;
  DeleteSavedEventWithoutRefresh({this.documentId});
  @override
  List<Object> get props => [this.documentId];
}

class BatchDeleteSavedEvents extends SavedEventsEvent {
  final List<String> documentIds;
  BatchDeleteSavedEvents({this.documentIds});
  @override
  List<Object> get props => this.documentIds;
}

class SwitchToSavedEventsScreen extends SavedEventsEvent {
  @override
  List<Object> get props => [];
}

class SwitchFromSavedEventsScreen extends SavedEventsEvent {
  @override
  List<Object> get props => [];
}