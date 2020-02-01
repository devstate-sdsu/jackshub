import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/widgets/index.dart';



class FoodScreen extends StatelessWidget {
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
                  itemBuilder: (context, index) => buildFoodListItem(context, snapshot.data.documents[index])
                );
              }
            ),
          ),
        ],
      )
    );
  }

  Widget buildFoodListItem(BuildContext context, DocumentSnapshot doc) {
    return EventsCard(
        name: doc['name'],
        //summary: doc['summary'],     DEPRECATED
        description: doc['description'],
        startTime: doc['start_time'],
        endTime: doc['end_time'],
        //timeUpdated: doc['time_updated'],
        image: doc['image'],
        littleLocation: doc['tiny_location'],
        bigLocation: doc['big_location'],
        //coords: doc['coords'],
        docId: doc.documentID,
    );
  }
}