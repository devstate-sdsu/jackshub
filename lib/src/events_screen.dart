import 'package:flutter/material.dart';
import 'widgets/events-menu-card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventsScreen extends StatelessWidget {
  Widget _buildEventsListItem(BuildContext context, DocumentSnapshot doc) {
    return Container(
      child: EventsMenuCard(
          name: doc['name'],
          summary: doc['summary'],
          time: doc['time'],
          timeUpdated: doc['time_updated'],
          img: doc['image'],
          location: doc['location'],
          coords: doc['coords'],
          docId: doc.documentID,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rainbow-tiles.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('eventsCol').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildEventsListItem(context, snapshot.data.documents[index])
            );
          }
      ),
    );
  }
}


