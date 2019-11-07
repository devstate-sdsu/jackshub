import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/saved_events_bloc.dart';
import 'bloc/saved_events_state.dart';
import 'widgets/events-menu-card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/saved-event-card.dart';
import 'widgets/saved-events.dart';

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

  Widget _buildSavedEventsListItem(BuildContext context, DocumentSnapshot doc) {
    return Container(
      child: SavedEventCard(
          name: doc['name'],
          img: doc['image'],
          docId: doc.documentID,
      ),
    );
  }

  Widget buildInitialSavedEvents() {
    return Container();
  }

  Widget buildLoadingSavedEvents() {
    return Container();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/autumn-studio-unsplash.jpg'),
          fit: BoxFit.cover,
        ),
      ),
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
              },
            ),
          ),
          // SavedEvents(),
          Expanded(
            flex: 3,
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
          ),
        ],
      )
    );
  }
}


