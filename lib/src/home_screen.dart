import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_event.dart';
import 'package:jackshub/src/repos/saved_events_repository.dart';
import 'bloc/saved_events_bloc.dart';
import 'widgets/menu-card.dart';
import 'widgets/events-menu-card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'events_screen.dart';


class HomeScreen extends StatelessWidget {


  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    return Container(
      child: new MenuCard(
          title: Text(doc['carrotType']),
          description: Text(doc['carrotType']),
          img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.')
      ),
    );
  }

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
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  "hoboHUB",
                  style: TextStyle(
                    fontFamily: 'Hobo',
                  )
                ),
                floating: true,
                pinned: true,
                snap: false,
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.event)),
                    Tab(icon: Icon(Icons.room_service)),
                    Tab(icon: Icon(Icons.fastfood)),
                  ]
                )
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              BlocProvider(
                builder: (context) => SavedEventsBloc(SavedEventsRepo())..add(GetSavedEvents()),
                child: EventsScreen(),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('newCol').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) =>
                                  _buildListItem(context, snapshot.data.documents[index])
                    );
                  }
              ),
              ListView(
                children: <Widget>[
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                  MenuCard(
                    title: Text('HELLO'),
                    description: Text('bitch'),
                    img: Image.network('https://cdn-images-1.medium.com/fit/c/200/200/0*UIFfL_qd3osLl4LE.',
                    fit: BoxFit.fill)
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }
}


