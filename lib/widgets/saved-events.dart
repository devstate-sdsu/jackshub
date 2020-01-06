import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/util/database_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/widgets/events-menu-card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_state.dart';


Widget _buildSavedEventsListItem(BuildContext context, DocumentSnapshot doc, bool favorite) {
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
        favorite: favorite
    );
}

Widget _buildWithSnapshotList(snapshot) {
  return BlocBuilder<SavedEventsBloc, SavedEventsState>(
    builder: (context, state) {
      if (state is SavedEventsInfoLoaded) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: snapshot.length,
          itemBuilder: (context, index) =>
            _buildSavedEventsListItem(
              context, 
              snapshot[index], 
              state.savedEventsIdsMap.containsKey(snapshot[index].documentID)
            )
        );
      }
      return Container(child: Text("Loading..."));
    },
  );

}

class SavedEvents extends StatefulWidget {
  final List<DocumentSnapshot> savedEvents;

  const SavedEvents({Key key, this.savedEvents}): super(key: key);

  @override
  _SavedEventsState createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {  
  List<SavedEvent> eventsList = new List<SavedEvent>();

  @override
  Widget build(BuildContext context) {
    return _buildWithSnapshotList(widget.savedEvents);
  }
}