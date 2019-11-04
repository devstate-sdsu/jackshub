import 'dart:async';

import 'bloc_provider.dart';
import '../database_helpers.dart';
import '../models/saved_event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SavedEventBloc implements BlocBase {
  final _savedEventsController = StreamController<List<DocumentSnapshot>>.broadcast();

  StreamSink<List<DocumentSnapshot>> get _inSavedEvents => _savedEventsController.sink;

  Stream<List<DocumentSnapshot>> get savedEvents => _savedEventsController.stream;

  final _addSavedEventController = StreamController<SavedEvent>.broadcast();
  StreamSink<SavedEvent> get inAddSavedEvent => _addSavedEventController.sink;

  SavedEventBloc() {
    listSavedEvents();

    _addSavedEventController.stream.listen(_handleAddSavedEvent);
  }

  @override
  void dispose() {
    _savedEventsController.close();
    _addSavedEventController.close();
  }

  Future<List<DocumentSnapshot>> _getSavedEventsInfo(List<String> docIdList) async {
    List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
    for (String docId in docIdList) {
        await Firestore.instance
          .collection('eventsCol')
          .document(docId)
          .get()
          .then((DocumentSnapshot ds) {
          // use ds as a snapshot
          print(ds.data['name']);
          snapshotList.add(ds);
        });
    }
    print("SNAPSHOT LIST BEFORE RETURNING: ");
    print(snapshotList);
    print("LENGTH OF IT: ");
    print(snapshotList.length);
    return snapshotList;
  }

  void listSavedEvents() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<SavedEvent> savedEvents = await helper.listSavedEvents();
    List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
    List<String> docIdList = new List<String>();
    print("THIS IS EVENTS LIST: " );
    savedEvents.forEach((event) => docIdList.add(event.documentId));
    _getSavedEventsInfo(docIdList).then((snapshotList) {
      print("THIS IS SNAPHSOT LIST: ");
      print(snapshotList);
      _inSavedEvents.add(snapshotList);
    });
  }

  void _handleAddSavedEvent(SavedEvent savedEvent) async {
    await DatabaseHelper.instance.insert(savedEvent);

    listSavedEvents();
  }
}