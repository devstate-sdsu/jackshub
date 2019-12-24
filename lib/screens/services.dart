import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/widgets/index.dart';



class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
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
    return ServicesCard(
        name: doc['name'],
        summary: doc['summary'],
        img: doc['image'],
        docId: doc.documentID,
    );
  }

}