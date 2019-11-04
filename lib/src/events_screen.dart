import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/data/blocs/bloc_provider.dart';
import 'package:jackshub/data/blocs/saved_events_bloc.dart';
import 'package:jackshub/src/widgets/saved-events.dart';
import 'package:jackshub/src/widgets/events-menu-card.dart';
import 'package:jackshub/src/widgets/saved-event-card.dart';
import 'package:flutter/widgets.dart';



class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  SavedEventBloc _savedEventBloc;

  @override
  void initState() {
    super.initState();
    _savedEventBloc = BlocProvider.of<SavedEventBloc>(context);
  }

  Widget _buildEventsListItem(BuildContext context, DocumentSnapshot doc, SavedEventBloc bloc) {
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
          savedEventBloc: bloc,
      ),
    );
  }

  Widget _buildSavedEventsListItem(BuildContext context, DocumentSnapshot doc) {
    return Container(
      child: SavedEventCard(
          name: doc['name'],
          img: doc['image'],
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
      child: Column(
        children: <Widget>[
          SavedEvents(_savedEventBloc),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('eventsCol').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) =>
                        _buildEventsListItem(context, snapshot.data.documents[index], _savedEventBloc)
                );
              }
            ),
          ),
        ],
      )
    );
  }
}


