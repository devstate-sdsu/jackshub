import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_event.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_state.dart';
import 'package:jackshub/src/repos/saved_events_repository.dart';



class SavedEventsBloc extends Bloc<SavedEventsEvent, SavedEventsState> {
  final SavedEventsRepo savedEventsRepo;

  SavedEventsBloc(this.savedEventsRepo);

  @override
  SavedEventsState get initialState => SavedEventsInitial();

  @override
  Stream<SavedEventsState> mapEventToState(
    SavedEventsEvent event,
  ) async* {
    print("EVENT: ");
    print(event);
    if (event is GetSavedEventsInfo) {
      try {
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsInfoFromLocal();
        yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while getting saved events info");
      }
    } else if (event is AddSavedEvent) {
      try {
        await savedEventsRepo.addSavedEventToLocal(event.eventInfo);
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsInfoFromLocal();
        yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while saving an event");
      }
    } else if (event is DeleteSavedEvent) {
      try {
        await savedEventsRepo.deleteSavedEventFromLocal(event.documentId);
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsInfoFromLocal();
        yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while deleting an event");
      }
    } else if (event is AddSavedEventWithoutRefresh) {
      try {
        await savedEventsRepo.addSavedEventToLocal(event.eventInfo);
        Map toDeleteMap = Map.from(state.toDeleteMap);
        toDeleteMap.remove(event.eventInfo.documentId);
        List<Map> toDeleteList = <Map>[];
        toDeleteMap.forEach((k, v) {
          toDeleteList.add({'key': k, 'value': v});
        });
        yield InSavedEventsScreen(savedEventsInfo: state.savedEventsInfo, toDeleteMap: toDeleteMap);
      } on Error {
        yield SavedEventsError("Something went wrong while saving an event");
      }
    } else if (event is DeleteSavedEventWithoutRefresh) {
      try {
        await savedEventsRepo.deleteSavedEventFromLocal(event.documentId);
        Map toDeleteMap = Map.from(state.toDeleteMap);
        toDeleteMap[event.documentId] = true;
        List<Map> toDeleteList = <Map>[];
        toDeleteMap.forEach((k, v) {
          toDeleteList.add({'key': k, 'value': v});
        });
        yield InSavedEventsScreen(savedEventsInfo: state.savedEventsInfo, toDeleteMap: toDeleteMap);
      } on Error {
        yield SavedEventsError("Something went wrong while deleting an event");
      }
    } else if (event is SwitchToSavedEventsScreen) {
      try {
        yield InSavedEventsScreen(savedEventsInfo: state.savedEventsInfo, toDeleteMap: {});
      } on Error {
        yield SavedEventsError("Something went wrong while switching screen states");
      }
    } else if (event is SwitchFromSavedEventsScreen) {
      if (state is InSavedEventsScreen) {
        try {
          final savedEventsInfo = await savedEventsRepo.fetchSavedEventsInfoFromLocal();
          yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
        } on Error {
          yield SavedEventsError("Something went wrong while getting saved events info");
        }
      } else yield state;
    }
  }
}
