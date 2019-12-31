import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/src/bloc/index.dart';
import 'package:jackshub/widgets/index.dart';



class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();

}

class _EventsScreenState extends State<EventsScreen>{
  var selectedFilter = 0;
  final Map<int, Widget> filteringTabs = const<int, Widget> {
    0: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text("All"),
        ), 
    1: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text("Saved"),
        ), 
  };
  List<Widget> buildFilters(BuildContext context) {
    return [
      buildEventsList(context),
      buildSavedEventsList(context),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: CupertinoSegmentedControl(
                children: filteringTabs,
                groupValue: selectedFilter,
                onValueChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
              ),
              flex: 1,
            ),
            Expanded(
              child: buildFilters(context)[selectedFilter],
              flex: 13,  
            ),
          ],
        )
      ),
    );
  }

  Widget buildSavedEventsList(BuildContext context) {
    return BlocListener<SavedEventsBloc, SavedEventsState>(
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
    );
  }

  Widget buildEventsList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => buildEventsListItem(context, snapshot.data.documents[index])
        );
      }
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

  // Temporary
  Widget buildInitialSavedEvents() {
    return Container();
  }

  // Temporary
  Widget buildLoadingSavedEvents() {
    return Container();
  }

}