import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jackshub/config/theme.dart';
import 'package:jackshub/screens/index.dart';

import 'package:jackshub/src/blocs/events_scroll/events_scroll_bloc.dart';
import 'package:jackshub/src/blocs/filter_tabs/filter_tabs_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/index.dart';
import 'package:jackshub/widgets/index.dart';



class EventsToggle extends StatefulWidget {
  @override
  _EventsToggle createState () => _EventsToggle();
}

class _EventsToggle extends State<EventsToggle> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  double slide = 0;

  List filterIcons = [
    Icons.zoom_out_map,
    Icons.group,
    Icons.directions_run,
    Icons.favorite,
  ];
  List<String> filterDisplayNames = [
    'All',
    'Clubs',
    'Sporting',
    'Favorites'
  ];
  List<String> filterTagNames = [
    'all',
    'clubs',
    'sporting'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: AppTheme.cardAnimateDuration
      )
    );
    _animation = Tween(
      begin: 1.0,
      end: 0.0
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.cardForwardCurve
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackOfEventsList = buildStackOfEventsLists(context);
    SavedEventsBloc savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);
    return Stack(
      children: <Widget>[
        MultiBlocListener(
          listeners: [
            BlocListener<EventsScrollBloc, EventsScrollState>(
              listener: (context, state) {
                slide = state.slide;
              }
            ),
            BlocListener<FilterTabsBloc, FilterTabsState>(
              listener: (context, state) {
                if (state is FilterTabSelected) {
                  if (state.selectedTabIndex == filterDisplayNames.indexOf('Favorites')) {
                    savedEventsBloc.add(SwitchToSavedEventsScreen());
                  } else {
                    savedEventsBloc.add(SwitchFromSavedEventsScreen());
                  }
                }
              }
            ),
          ],
          child: BlocBuilder<FilterTabsBloc, FilterTabsState>(
            builder: (context, state) {
              if (state is FilterTabSelected) {
                return stackOfEventsList[state.selectedTabIndex];
              }
              return stackOfEventsList[0];
            } 
          )
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) => BlocBuilder<EventsScrollBloc, EventsScrollState>(
              builder: (context, state) {
                return Transform.translate(
                  offset: Offset(0.0, slide),
                  child: buildFilterTabs(context)
                );
              }
            )
          )
        )
      ],
    );
  }
  


  Widget buildFilterTabs(blocContext) {
    double screenWidth = MediaQuery.of(blocContext).size.width;
    double screenHeight = MediaQuery.of(blocContext).size.width;
    // double filterTabsSpacerWidth = screenWidth * AppTheme.filterTabsSpacerPercent;
    // double filterTabsBorderRadius = screenWidth * AppTheme.filterTabsBorderRadiusPercent;
    FilterTabsBloc filterTabsBloc = BlocProvider.of<FilterTabsBloc>(blocContext);
    EventsScrollBloc eventsScrollBloc = BlocProvider.of<EventsScrollBloc>(blocContext);
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, screenHeight * AppTheme.filterTabsBottomPaddingPercent),
      child: Container(
        height: screenHeight * AppTheme.filterTabsHeightPercent,
        width: screenWidth,
        child: ListView.builder(
          key: PageStorageKey('FilterTabs!'),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: filterIcons.length,
          itemBuilder: (context, index) {
            return FilterTabButton(
              filterTabsBloc: filterTabsBloc,
              eventsScrollBloc: eventsScrollBloc,
              tabIndex: index,
              filterIcons: filterIcons,
              filterDisplayNames: filterDisplayNames,
            );
            // return FlatButton(
            //   padding: EdgeInsets.fromLTRB(filterTabsSpacerWidth, 0.0, filterTabsSpacerWidth, 0.0),
            //   splashColor: Colors.transparent,
            //   highlightColor: Colors.transparent,
            //   onPressed: () {
            //     filterTabsBloc.add(SelectFilterTab(tabIndex: index));
            //     eventsScrollBloc.add(TabSelected());
            //   },
            //   child: Container(
            //     height: screenHeight * AppTheme.filterTabsHeightPercent,
            //     width: screenWidth * AppTheme.filterTabsWidthPercent,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(filterTabsBorderRadius)
            //       ),
            //       color: Theme.of(context).indicatorColor,
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           Expanded(
            //             child: Icon(
            //               filterIcons[index],
            //               color: Theme.of(context).backgroundColor,
            //               size: screenWidth * AppTheme.filterTabsIconSizePercent
            //             ),
            //           ),
            //           Expanded(
            //             child: Text(
            //               filterDisplayNames[index],
            //               style: TextStyle(
            //                 color: Theme.of(context).backgroundColor,
            //                 fontSize: screenWidth * AppTheme.filterTabsTextSizePercent,
            //               )
            //             ),
            //           )
            //         ],
            //       ),
            //     )
            //   ),
            // );
          }
        ),
      ),
    );
  }



  List<Widget> buildStackOfEventsLists(context) {
    List<Widget> masterList = <Widget>[];
    filterTagNames.forEach((filterName) {
      masterList.add(EventsScreen(filter: filterName));
    });
    masterList.add(SavedEvents());
    return masterList;
  }


}