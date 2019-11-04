import 'dart:async';

import 'bloc_provider.dart';
import '../database_helpers.dart';
import '../models/saved_event_model.dart';

class EventsListBloc implements BlocBase {
  final _saveEventController = StreamController<SavedEvent>.broadcast();
  StreamSink<SavedEvent> get inSaveNote => _saveEventController.sink;

  final _unsaveEventController = StreamController<String>.broadcast();
  StreamSink<String> get inDeleteEvent => _unsaveEventController.sink;

  final _eventUnsavedController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDeleted => _eventUnsavedController.sink;
  Stream<bool> get deleted => _eventUnsavedController.stream;

  EventsListBloc() {
    _saveEventController.stream.listen(_handleSaveEvent);
    _unsaveEventController.stream.listen(_handleUnsaveEvent);
  }

  @override
  void dispose() {
    _saveEventController.close();
    _unsaveEventController.close();
    _eventUnsavedController.close();
  }

  void _handleSaveEvent(SavedEvent event) async {
    await DatabaseHelper.instance.insert(event);
  }

  void _handleUnsaveEvent(String id) async {
    await DatabaseHelper.instance.delete(id);

    _inDeleted.add(true);
  }
}