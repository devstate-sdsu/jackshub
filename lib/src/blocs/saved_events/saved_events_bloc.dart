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
    if (event is GetSavedEventsInfo) {
      try {
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsFromLocal();
        yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while getting saved events info");
      }
    } else if (event is AddSavedEvent) {
      try {
        await savedEventsRepo.addSavedEventToLocal(event.eventInfo);
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsFromLocal();
        yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while saving an event");
      }
    } else if (event is DeleteSavedEvent) {
      try {
        await savedEventsRepo.deleteSavedEventFromLocal(event.documentId);
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsFromLocal();
        yield SavedEventsInfoLoadedFromLocal(savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong while saving an event");
      }
    }
  }
}
