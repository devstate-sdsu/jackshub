import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/database_helpers.dart';



abstract class SavedEventsRepository {
  Future<List<DocumentSnapshot>> fetchSavedEvents();
  Future<List<String>> fetchSavedEventsIds();
  Future<List<DocumentSnapshot>> fetchSavedEventsInfo(List<String> savedEventsIds);
}

Future<List<DocumentSnapshot>> _list() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<SavedEvent> savedEvents = await helper.listSavedEvents();
  List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
  List<String> docIdList = new List<String>();
  savedEvents.forEach((event) => docIdList.add(event.documentId));
  snapshotList = await _getSavedEventsInfo(docIdList);
  return snapshotList;
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
        snapshotList.add(ds);
      });
  }
  return snapshotList;
}



class SavedEventsRepo implements SavedEventsRepository {
  @override
  Future<List<DocumentSnapshot>> fetchSavedEvents() async {
    return await _list();
  }

  @override
  Future<List<String>> fetchSavedEventsIds() async {
    List<String> docIdList = new List<String>();
    DatabaseHelper helper = DatabaseHelper.instance;
    List<SavedEvent> savedEvents = await helper.listSavedEvents();
    savedEvents.forEach((event) => docIdList.add(event.documentId));
    return docIdList;
  }


  @override
  Future<List<DocumentSnapshot>> fetchSavedEventsInfo(List<String> savedEventsIds) async {
    List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
    for (String docId in savedEventsIds) {
        await Firestore.instance
          .collection('eventsCol')
          .document(docId)
          .get()
          .then((DocumentSnapshot ds) {
          // use ds as a snapshot
          snapshotList.add(ds);
        });
    }
    return snapshotList;
  }
}