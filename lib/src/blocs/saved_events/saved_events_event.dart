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