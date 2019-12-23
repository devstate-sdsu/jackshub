import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:jackshub/src/bloc/saved_events_event.dart';
import 'package:jackshub/src/bloc/saved_events_state.dart';
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
    if (event is GetSavedEvents) {
      yield* _mapSavedEventsToState();
    } else if (event is LoadEvents) {
      try {
        final savedEvents = await savedEventsRepo.fetchSavedEvents();
        yield SavedEventsLoaded(savedEvents);
      } on Error {
        yield SavedEventsError("No events sorry sis");
      }
    }
  }

  Stream<SavedEventsState> _mapSavedEventsToState()  async* {
      try {
        final savedEvents = await savedEventsRepo.fetchSavedEvents();
        yield SavedEventsLoaded(savedEvents);
      } on Error catch (e) {
        print("FRIGGIN ERROR: ");
        print(e);
        yield SavedEventsError("No events sorry sis");
      }
  }
}
