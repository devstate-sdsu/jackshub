import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:jackshub/util/database_helpers.dart';



abstract class SavedEventsState extends Equatable {
  final Map savedEventsIdsMap;
  SavedEventsState() : savedEventsIdsMap = Map();
}



class SavedEventsInitial extends SavedEventsState {
  SavedEventsInitial();
  @override
  List<Object> get props => [];
}



class SavedEventsLoading extends SavedEventsState {
  SavedEventsLoading();
  @override
  List<Object> get props => [];
}


class SavedEventsLoaded extends SavedEventsState {
  final List<DocumentSnapshot> savedEvents;
  final Map savedEventsMap;
  SavedEventsLoaded(this.savedEvents)
    : savedEventsMap = Map.fromIterable(
      savedEvents, 
      key: (savedEvent) => savedEvent.documentID, value: (savedEvent) => true
    );

  @override
  List<Object> get props => [savedEvents];
}


class SavedEventsError extends SavedEventsState {
  final String message;
  SavedEventsError(this.message);
  @override
  List<Object> get props => [message];
}

class SavedEventsInfoLoadedFromLocal extends SavedEventsState {
  final Map savedEventsIdsMap;
  final List<EventInfo> savedEventsInfo;
  SavedEventsInfoLoadedFromLocal(this.savedEventsInfo)
      : savedEventsIdsMap = Map.fromIterable(
      savedEventsInfo,
      key: (event) => event.documentId,
      value: (_) => true,
    );
  @override
  List<Object> get props => [savedEventsInfo];
}

