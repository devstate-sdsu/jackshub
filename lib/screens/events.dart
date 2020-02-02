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


  int groupval = 0;
  List savedEventsList;

  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text("All"),
    1: Text("Favorite"),
  };

  List <Widget> bodies = 
  [
    EventsScreen(),
    SavedEvents(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodies[groupval],
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
       // title: Text("title", style: TextStyle(color: Colors.black),),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 5.0),
          child: Padding(
            padding: EdgeInsets.only(top : 1.0, bottom : 10.0),
            child: Row(children: <Widget>[
              SizedBox(
                width : 15.0
                ,),
                Expanded(child: CupertinoSegmentedControl(
                  groupValue: groupval,
                  onValueChanged: (changeFromGroupValue){
                    setState(() {
                      groupval = changeFromGroupValue;
                    });
                  } , 
                  children: logoWidgets ,
                ))
            ],)
          )
        )
      )
      
    );
  }
}

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: BlocListener<SavedEventsBloc, SavedEventsState>(
        listener: (context, state) {
          if (state is SavedEventsError) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<SavedEventsBloc, SavedEventsState>(
          builder: (context, state) {
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
                    itemBuilder: (_, index) => buildEventsListItem(
                      snapshot.data.documents[index], 
                      state is SavedEventsLoaded
                        ? state.savedEventsMap.containsKey(snapshot.data.documents[index].documentID)
                        : false
                    )
                  );
                }
              );
          }
        ),
      )
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

//   // Temporary
//   Widget buildInitialSavedEvents() {
//     return Container();
//   }

//   // Temporary
//   Widget buildLoadingSavedEvents() {
//     return Container();
//   }

 }