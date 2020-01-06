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
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsInfoLoaded) {
          return state.savedEventsInfo.length == 0 ? Container() : SavedEvents(savedEvents: state.savedEventsInfo);
        } 
        return Container(child: Text("Fetching saved events..."));
      }
    );
  }

  Widget buildEventsList(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsIdsLoaded || state is SavedEventsInfoLoaded) {
          Map ultimateDocIds = state.savedEventsIdsMap;
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Fetching events...');
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  bool favorite = ultimateDocIds.containsKey(snapshot.data.documents[index].documentID);
                  return buildEventsListItem(context, snapshot.data.documents[index], favorite);
                }
              );
            }
          ); 
        }
        return Container(
          child: Text("Loading")
        );
      },
    );
    
   
  }

  Widget buildEventsListItem(BuildContext context, DocumentSnapshot doc, bool favorite) {
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
        favorite: favorite,
    );
  }
}