import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/src/bloc/index.dart';
import 'package:jackshub/widgets/index.dart';



class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          BlocListener<SavedEventsBloc, SavedEventsState>(
            listener: (context, state) {
              if (state is SavedEventsError) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: BlocBuilder<SavedEventsBloc, SavedEventsState>(
              builder: (context, state) {
                if (state is SavedEventsInitial) {
                  return buildInitialSavedEvents();
                } else if (state is SavedEventsLoading) {
                  return buildLoadingSavedEvents();
                } else if (state is SavedEventsLoaded) {
                  return state.savedEvents.length == 0 ? Container() : SavedEvents(savedEvents: state.savedEvents);
                } else if (state is SavedEventsError) {
                  return buildInitialSavedEvents();
                }
                return Container();
              }
            ),
          ),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => buildEventsListItem(context, snapshot.data.documents[index])
                );
              }
            ),
          ),
        ],
      )
    );
  }

  Widget buildEventsListItem(BuildContext context, DocumentSnapshot doc) {
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

  Widget buildSavedEventsListItem(BuildContext context, DocumentSnapshot doc) {
    return SavedEventCard(
      name: doc['name'],
      img: doc['image'],
      docId: doc.documentID,
    );
  }

  // Temporary
  Widget buildInitialSavedEvents() {
    return Container();
  }

  // Temporary
  Widget buildLoadingSavedEvents() {
    return Container();
  }

}