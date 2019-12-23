import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/widgets/index.dart';



class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => buildServicesListItem(context, snapshot.data.documents[index])
                );
              }
            ),
          ),
        ],
      )
    );
  }

  Widget buildServicesListItem(BuildContext context, DocumentSnapshot doc) {
    return EventsMenuCard(
        name: doc['name'],
        summary: doc['summary'],
        description: doc['description'],
        startTime: doc['start_time'],
        endTime: doc['end_time'],
        timeUpdated: doc['time_updated'],
        img: doc['image'],
        tinyLocation: doc['tiny_location'],
        bigLocation: doc['big_location'],
        coords: doc['coords'],
        docId: doc.documentID,
    );
  }

}