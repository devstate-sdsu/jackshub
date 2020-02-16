import 'package:equatable/equatable.dart';
import 'package:jackshub/util/database_helpers.dart';

abstract class SavedEventsState extends Equatable {
  final Map savedEventsIdsMap;
  final Map toDeleteMap;
  final List<EventInfo> savedEventsInfo;
  SavedEventsState() : savedEventsIdsMap = Map(), toDeleteMap = Map(), savedEventsInfo = List<EventInfo>();
}

class SavedEventsInitial extends SavedEventsState {
  SavedEventsInitial();
  @override
  List<Object> get props => [];
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

class InSavedEventsScreen extends SavedEventsState {
    final Map toDeleteMap;
    final List<EventInfo> savedEventsInfo;
    InSavedEventsScreen({this.savedEventsInfo, this.toDeleteMap});
    @override
    List<Object> get props => [toDeleteMap];
}



