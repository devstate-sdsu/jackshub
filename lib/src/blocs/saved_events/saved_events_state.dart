import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';



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

class SavedEventsIdsLoaded extends SavedEventsState {
  final List<String> savedEventsIds;
  final Map savedEventsIdsMap;
  SavedEventsIdsLoaded(this.savedEventsIds)
    : savedEventsIdsMap = Map.fromIterable(
      savedEventsIds,
      key: (id) => id,
      value: (_) => true,
    );

  @override
  List<Object> get props => [savedEventsIds];
}

class SavedEventsInfoLoaded extends SavedEventsState {
  final List<String> savedEventsIds;
  final Map savedEventsIdsMap;
  final List<DocumentSnapshot> savedEventsInfo;
  SavedEventsInfoLoaded(this.savedEventsIds, this.savedEventsInfo)
      : savedEventsIdsMap = Map.fromIterable(
      savedEventsIds,
      key: (id) => id,
      value: (_) => true,
    );
  @override
  List<Object> get props => [savedEventsInfo];
}

