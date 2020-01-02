import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';



abstract class SavedEventsState extends Equatable {
  const SavedEventsState();
}



class SavedEventsInitial extends SavedEventsState {
  const SavedEventsInitial();
  @override
  List<Object> get props => [];
}



class SavedEventsLoading extends SavedEventsState {
  const SavedEventsLoading();
  @override
  List<Object> get props => [];
}


class SavedEventsLoaded extends SavedEventsState {
  final List<DocumentSnapshot> savedEvents;
  final Map savedEventsMap;
  SavedEventsLoaded(this.savedEvents)
    : savedEventsMap = Map.fromIterable(
      savedEvents,
      key: (doc) => doc.documentID,
      value: (_) => true,
    );
  @override
  List<Object> get props => [savedEvents];
}



class SavedEventsError extends SavedEventsState {
  final String message;
  const SavedEventsError(this.message);
  @override
  List<Object> get props => [message];
}
