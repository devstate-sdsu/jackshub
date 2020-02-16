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
    print(event);
    if (event is GetSavedEvents) {
      yield* _mapSavedEventsToState();
    } else if (event is LoadEvents) {
      try {
        final savedEvents = await savedEventsRepo.fetchSavedEvents();
        yield SavedEventsLoaded(savedEvents);
      } on Error {
        yield SavedEventsError("No events sorry sis");
      }
    } else if (event is GetSavedEventsIds) {
      try {
        final savedEventsIds = await savedEventsRepo.fetchSavedEventsIds();
        yield SavedEventsIdsLoaded(savedEventsIds);
      } on Error {
        yield SavedEventsError("Something went wrong");
      }
    } else if (event is LoadSavedEventsInfo || event is GetSavedEventsInfo) {
      try {
        final savedEventsIds = await savedEventsRepo.fetchSavedEventsIds();
        yield SavedEventsIdsLoaded(savedEventsIds);
        final savedEventsInfo = await savedEventsRepo.fetchSavedEventsInfo(savedEventsIds);
        yield SavedEventsInfoLoaded(savedEventsIds, savedEventsInfo);
      } on Error {
        yield SavedEventsError("Something went wrong");
      }
    }
  }

  Stream<SavedEventsState> _mapSavedEventsToState()  async* {
      try {
        final savedEvents = await savedEventsRepo.fetchSavedEvents();
        yield SavedEventsLoaded(savedEvents);
      } on Error catch (e) {
        yield SavedEventsError("No events sorry sis");
      }
  }
}
