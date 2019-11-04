import '../database_helpers.dart';

// Saved Events Datamodel
class SavedEvent {
  String documentId;

  SavedEvent(this.documentId);

    // convenience constructor to create a Word object
  SavedEvent.fromMap(Map<String, dynamic> map) {
    print(map[docId]);
    documentId = map[docId];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      docId: documentId
    };
    return map;
  }
}