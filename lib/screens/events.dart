import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/src/blocs/filter_tabs/filter_tabs_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/index.dart';
import 'package:jackshub/widgets/ColorLoader.dart';
import 'package:jackshub/widgets/index.dart';
import 'package:jackshub/widgets/saved-events.dart';


class EventsToggle extends StatefulWidget {
  @override
  _EventsToggleState createState() => _EventsToggleState();
}

class _EventsToggleState extends State<EventsToggle> with TickerProviderStateMixin {
  List<Widget> stackOfEventsLists;
  int selectedTabIndex = 0;
  List filterIcons = [
    Icons.zoom_out_map,
    Icons.group,
    Icons.directions_run,
    Icons.favorite,
  ];
  List filterDisplayNames = [
    'All',
    'Clubs',
    'Sporting',
    'Favorites'
  ];
  List<String> filterTagNames = [
    'all',
    'sporting',
    'clubs'
  ];

  initState() {
    super.initState();
    stackOfEventsLists = buildStackOfEventsLists();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocListener<FilterTabsBloc, FilterTabsState>(
          listener: (context, state) {
            if (state is FilterTabsInitial) {
              selectedTabIndex = 0;
            } else if (state is FilterTabSelected) {
              selectedTabIndex = state.selectedTabIndex;
            }
          },
          child: BlocBuilder<FilterTabsBloc, FilterTabsState>(
            builder: (context, state) {
              return stackOfEventsLists[selectedTabIndex];
            } 
          )
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: buildFilterTabs(context),
        )
      ],
    );
  }

  Widget buildFilterTabs(blocContext) {
    double screenWidth = MediaQuery.of(blocContext).size.width;
    FilterTabsBloc filterTabsBloc = BlocProvider.of<FilterTabsBloc>(blocContext);
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
      child: Container(
        height: 60.0,
        width: screenWidth,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(width: 10.0);
          },
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: filterIcons.length,
          itemBuilder: (context, index) {
            return FlatButton(
              padding: EdgeInsets.all(0.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                filterTabsBloc.add(SelectFilterTab(tabIndex: index));
              },
              child: Container(
                height: 60.0,
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0)
                  ),
                  color: Colors.pink,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Icon(
                          filterIcons[index],
                          color: Colors.white,
                          size: 24.0
                        ),
                      ),
                      Expanded(
                        child: Text(
                          filterDisplayNames[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          )
                        ),
                      )
                    ],
                  ),
                )
              ),
            );
          }
        ),
      ),
    );
  }

  List<Widget> buildStackOfEventsLists() {
    List<Widget> masterList = <Widget>[];
    filterTagNames.forEach((filterName) {
      masterList.add(EventsScreen(filter: filterName));
    });
    masterList.add(SavedEvents());
    return masterList;
  }
}

class EventsScreen extends StatelessWidget {
  final String filter;
  EventsScreen({this.filter});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsIdsLoaded || state is SavedEventsInfoLoaded) {
          Map ultimateDocIds = state.savedEventsIdsMap;
          return StreamBuilder<QuerySnapshot>(
            stream: this.filter == 'all' ? 
              Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots() :
              Firestore.instance.collection('eventsCol').where('tags', arrayContains: this.filter).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: ColorLoader5()
                );
              }
              return Container(
                color: Theme.of(context).backgroundColor,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    bool favorite = ultimateDocIds.containsKey(snapshot.data.documents[index].documentID);
                    return buildEventsListItem(snapshot.data.documents[index], favorite);
                  }
                )
              );
            }
          ); 
        }
        return Center(
          child: ColorLoader5()
        );
      },
    );
    
   
  }

  static Widget buildEventsListItem(DocumentSnapshot doc, bool favorite) {
    final tags = doc['tags'];
    if (
      tags.contains('sporting')
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
