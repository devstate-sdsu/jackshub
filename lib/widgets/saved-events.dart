import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/screens/events.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/util/database_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'saved-event-card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_state.dart';


Widget _buildSavedEventsListItem(BuildContext context, DocumentSnapshot doc) {
  return Container(
    child: SavedEventCard(
        name: doc['name'],
        img: doc['image'],
        docId: doc.documentID,
    ),
  );
}

Widget _buildWithSnapshotList(snapshot) {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.length,
      itemBuilder: (context, index) =>
          _buildSavedEventsListItem(context, snapshot[index])
  );
}

Widget buildInitialSavedEvents() {
  return Container(
    child: Text(
      "Initializing..."
    ),
  );
}

Widget buildLoadingSavedEvents() {
  return Container(
    child: Text(
      "Loading..."
    ),
  );
}


class SavedEvents extends StatefulWidget {
 // final List<DocumentSnapshot> savedEvents;

  const SavedEvents({Key key}): super(key: key);

  @override
  _SavedEventsState createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {
  
  List<SavedEvent> eventsList = new List<SavedEvent>();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if(state is SavedEventsLoaded)
        {
        return ListView.builder(
          itemCount: state.savedEvents.length,
          itemBuilder: (_, index) => EventsScreen.buildEventsListItem(
            state.savedEvents[index], 
            true
          )
        );
      }
      
      },
    );
  }
}

