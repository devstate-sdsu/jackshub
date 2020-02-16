import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/database_helpers.dart';



abstract class SavedEventsRepository {
  Future<bool> addSavedEventToLocal(Map event);
  Future<List<String>> fetchSavedEventsIds();
  Future<List<DocumentSnapshot>> fetchSavedEventsInfoFromLocal(List<String> savedEventsIds);
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

EventInfo convertEventToLocalSchema(Map event) {

}

class SavedEventsRepo implements SavedEventsRepository {
  static final DatabaseHelper db = DatabaseHelper.instance;
  @override
  Future<bool> addSavedEventToLocal(Map event) async {

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
}