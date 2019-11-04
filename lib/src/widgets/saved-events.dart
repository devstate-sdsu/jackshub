import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../database_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'saved-event-card.dart';


Widget _buildSavedEventsListItem(BuildContext context, DocumentSnapshot doc) {
    print("THIS IS SNAPSHOT IN BUILDER: ");
    print(doc['name']);
    return Container(
      child: SavedEventCard(
          name: doc['name'],
          img: doc['image'],
          docId: doc.documentID,
      ),
    );
  }


class SavedEvents extends StatefulWidget {
  @override
  _SavedEventsState createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {
  Future<List<DocumentSnapshot>> _list() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<SavedEvent> savedEvents = await helper.listSavedEvents();
    List<DocumentSnapshot> snapshotList = new List<DocumentSnapshot>();
    List<String> docIdList = new List<String>();
    print("THIS IS EVENTS LIST: " );
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

  
  List<SavedEvent> eventsList = new List<SavedEvent>();


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _list(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  _buildSavedEventsListItem(context, snapshot.data[index])
          );
        },
      ),
    );
  }
}
