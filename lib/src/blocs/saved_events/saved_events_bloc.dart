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
    if (event is GetSavedEventsIds) {
      try {
        final savedEventsIds = await savedEventsRepo.fetchSavedEventsIds();
        yield SavedEventsIdsLoaded(savedEventsIds);
      } on Error {
        yield SavedEventsError("Something went wrong while gettng saved events IDs");
      }
    } else if (event is GetSavedEventsInfo) {
      try {
        final savedEventsIds = await savedEventsRepo.fetchSavedEventsIds();
        yield SavedEventsIdsLoaded(savedEventsIds);
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsFromLocal();
        print("THIS IS SAVED EVENTS INFOOOO");
        print(savedEventsInfo);
        yield SavedEventsInfoLoadedFromLocal(savedEventsIds, savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while getting saved events info");
      }
    } else if (event is AddSavedEvent) {
      try {
        final addSuccess = await savedEventsRepo.addSavedEventToLocal(event.eventInfo);
        if (addSuccess) {
          print("HAHA YES");
          print(addSuccess);
        } else {
          print("HAHA NO");
          print(addSuccess);
        }
      } on Error {
        yield SavedEventsError("Something went wrong while saving an event");
      }
    } else if (event is DeleteSavedEvent) {
      try {
        final deleteSuccess = await savedEventsRepo.deleteSavedEventFromLocal(event.documentId);
        if (deleteSuccess) {
          print("HAHA DELETED YES");
          print(deleteSuccess);
        } else {
          print("HAHA DELETED NO");
          print(deleteSuccess);
        }
      } on Error {
        yield SavedEventsError("Something went wrong while saving an event");
      }
    }
  }
}
