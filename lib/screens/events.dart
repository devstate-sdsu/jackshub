import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/src/bloc/index.dart';
import 'package:jackshub/widgets/ColorLoader.dart';
import 'package:jackshub/widgets/index.dart';
import 'package:jackshub/widgets/saved-events.dart';


class EventsToggle extends StatefulWidget {
  @override
  _EventsToggleState createState() => _EventsToggleState();
}

class _EventsToggleState extends State<EventsToggle> {
  int selectedScreenIdx = 0;
  List savedEventsList;

  final Map<int, Widget> selectionTexts = const<int, Widget> {
    0: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text("All"),
        ), 
    1: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text("Saved"),
        ), 
  };

  

  List <Widget> screens = 
  [
    EventsScreen(),
    SavedEvents(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: CupertinoSegmentedControl(
              groupValue: selectedScreenIdx,
              onValueChanged: (screenIdx){
                setState(() {
                  selectedScreenIdx = screenIdx;
                });
              }, 
              children: selectionTexts,
            ),
          ),
          Expanded(child: screens[selectedScreenIdx]),
        ],
      );
      // appBar: AppBar(
      //   elevation: 2.0,
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   bottom: PreferredSize(
      //     preferredSize: Size(double.infinity, 5.0),
      //     child: Padding(
      //       padding: EdgeInsets.only(top : 1.0, bottom : 10.0),
      //       child: Row(
      //         children: <Widget>[
      //           SizedBox(
      //             width : 15.0
      //           ),
      //           Expanded(
      //             child: CupertinoSegmentedControl(
      //               groupValue: selectedScreenIdx,
      //               onValueChanged: (screenIdx){
      //                 setState(() {
      //                   selectedScreenIdx = screenIdx;
      //                 });
      //               }, 
      //               children: selectionTexts ,
      //             )
      //           )
      //         ],
      //       )
      //     )
      //   )
      // )
      
    // );
  }
}

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsIdsLoaded || state is SavedEventsInfoLoaded) {
          Map ultimateDocIds = state.savedEventsIdsMap;
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: ColorLoader5()
                  );
              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  bool favorite = ultimateDocIds.containsKey(snapshot.data.documents[index].documentID);
                  return buildEventsListItem(snapshot.data.documents[index], favorite);
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

  static Widget buildEventsListItem(DocumentSnapshot doc, bool favorite) {
    //String imageurl = doc['image'];   DEPRECATED
    String titlename = doc['name'];
    if (
      //imageurl.contains("teaser") || 
      titlename.contains("Basketball") ||
      titlename.contains("basketball") ||
      titlename.contains("College of") ||
      titlename.contains("Wrestling") ||
      titlename.contains("Track") ||
      titlename.contains("Preview") ||
      titlename.contains("Theatre")
      ) {
      return EventsSmallCard(
        name: doc['name'],
        image: doc['image'],
        bigLocation: doc['big_location'],
        littleLocation: doc['tiny_location'],
        startTime: doc['start_time'],
        endTime: doc['end_time'],
        favorite: favorite,
        docId: doc.documentID
      );
    } else {
      return EventsCard(
        name: doc['name'],
        image: doc['image'],
        description: doc['description'],
        //summary: doc['summary'],   DEPRECATED
        bigLocation: doc['big_location'],
        littleLocation: doc['tiny_location'],
        startTime: doc['start_time'],
        endTime: doc['end_time'],
        favorite: favorite,
        docId: doc.documentID
      );
    }
  }
}
