import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/blocs/events_scroll/events_scroll_bloc.dart';
import 'package:jackshub/src/blocs/filter_tabs/filter_tabs_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/index.dart';
import 'package:jackshub/screens/index.dart';
import 'package:jackshub/src/repos/saved_events_repository.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if (Theme.of(context).brightness == Brightness.dark) {
    //   print("DARK MODE!");
    // } else {
    //   print("LIGHT MODE!");
    // }
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  "jacksHUB",
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
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => SavedEventsBloc(SavedEventsRepo())..add(GetSavedEventsInfo()),
              ),
              BlocProvider(
                create: (_) => FilterTabsBloc(),
              ),
              BlocProvider(
                create: (_) => EventsScrollBloc(),
              )
            ],
            child: TabBarView(
              children: <Widget>[
                EventsToggle(),
                ServicesScreen(),
                ServicesScreen()
              ],
            ),
          ),
        )
      )
    );
  }
}