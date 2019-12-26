import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/screens/services-detail.dart';
import 'package:jackshub/src/bloc/index.dart';
import 'package:jackshub/screens/index.dart';
import 'package:jackshub/src/repos/saved_events_repository.dart';



class HomeScreen extends StatelessWidget {
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
                  ],
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
              BlocProvider(
                builder: (context) => SavedEventsBloc(SavedEventsRepo())..add(GetSavedEvents()),
                child: ServicesScreen(),
              ),
              BlocProvider(
                builder: (context) => SavedEventsBloc(SavedEventsRepo())..add(GetSavedEvents()),
                child: ServicesScreen(),
              )
            ],
          ),
        )
      )
    );
  }
}