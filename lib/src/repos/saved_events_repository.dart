import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/database_helpers.dart';



abstract class SavedEventsRepository {
  Future addSavedEventToLocal(EventInfo event);
  Future deleteSavedEventFromLocal(String documentId);
  Future<List<EventInfo>> fetchSavedEventsInfoFromLocal();
}

class SavedEventsRepo implements SavedEventsRepository {
  static final DatabaseHelper db = DatabaseHelper.instance;
  @override
  Future addSavedEventToLocal(EventInfo event) async {
    bool success = await db.insertSavedEventInfo(event);
    if (!success) {
      throw 'Failed database insert';
    }
    return success;
  }

  @override
  Future deleteSavedEventFromLocal(String documentId) async {
    bool success = await db.deleteSavedEventInfo(documentId);
    if (!success) {
      throw 'Failed database delete';
    }
    return success;
  }

  @override
  Future<List<EventInfo>> fetchSavedEventsInfoFromLocal() async {
    return await db.listSavedEventsInfo();
  }

}