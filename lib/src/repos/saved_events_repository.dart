import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/database_helpers.dart';



abstract class SavedEventsRepository {
  Future addSavedEventToLocal(EventInfo event);
  Future deleteSavedEventFromLocal(String documentId);
  Future<List<String>> fetchSavedEventsIds();
  Future<List<DocumentSnapshot>> fetchSavedEventsInfoFromLocal(List<String> savedEventsIds);
  Future<List<EventInfo>> fetchSavedEventsFromLocal();
}

// Old function that retrieved saved events from firebase one call by one call
// Future<List<DocumentSnapshot>> _getSavedEventsInfo(List<String> docIdList) async {
//   List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
//   for (String docId in docIdList) {
//       await Firestore.instance
//         .collection('eventsCol')
//         .document(docId)
//         .get()
//         .then((DocumentSnapshot ds) {
//         // use ds as a snapshot
//         snapshotList.add(ds);
//       });
//   }
//   return snapshotList;
// }

class SavedEventsRepo implements SavedEventsRepository {
  static final DatabaseHelper db = DatabaseHelper.instance;
  @override
  Future addSavedEventToLocal(EventInfo event) async {
    int success = await db.insertSavedEventInfo(event);
    return success;
  }

  @override
  Future deleteSavedEventFromLocal(String documentId) async {
    int success = await db.deleteSavedEventInfo(documentId);
    return success;
  }

  @override
  Future<List<String>> fetchSavedEventsIds() async {
    List<String> docIdList = new List<String>();
    List<SavedEventId> savedEvents = await db.listSavedEventsIds();
    savedEvents.forEach((event) => docIdList.add(event.documentId));
    return docIdList;
  }

  @override
  Future<List<DocumentSnapshot>> fetchSavedEventsInfoFromLocal(List<String> savedEventsIds) async {
    List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
    await Firestore.instance
      .collection('eventsCol')
      .where('__name__', whereIn: savedEventsIds)
      .getDocuments()
      .then((ds) {
      // use ds as a snapshot
      snapshotList = ds.documents;
    });
    return snapshotList;
  }

  @override
  Future<List<EventInfo>> fetchSavedEventsFromLocal() async {
    return await db.listSavedEventsInfo();
  }

}