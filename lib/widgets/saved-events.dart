import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/screens/events.dart';
import 'package:jackshub/src/blocs/events_scroll/events_scroll_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_bloc.dart';
import 'package:jackshub/widgets/ColorLoader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_state.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget buildLoadingSavedEvents() {
  return Container(
    child: ColorLoader5(),
  );
}

class SavedEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.width;
    EventsScrollBloc eventsScrollBloc = BlocProvider.of<EventsScrollBloc>(context);
    return NotificationListener(
      child: BlocBuilder<SavedEventsBloc, SavedEventsState>(
        builder: (context, state) {
          print("NOTILISTENER LENGTH: ");
          print(state.savedEventsInfo.length);
          if (state is SavedEventsInfoLoadedFromLocal) {
            if (state.savedEventsInfo.length == 0) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_dissatisfied,
                        color: Theme.of(context).accentColor,
                        size : 40.0
                      ),
                      SizedBox(
                        height: 15.0
                      ),
                      AutoSizeText(
                        "You have not yet favorited an event!",
                        maxLines: 2,
                        maxFontSize: AppTheme.cardDescriptionTextSize.max,
                        minFontSize: AppTheme.cardDescriptionTextSize.min,
                        style: Theme.of(context).textTheme.caption
                      )
                    ],
                  )
                )
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor
                ),
                child: ListView.builder(
                  key: PageStorageKey('SavedEvents!Initial'),
                  padding: EdgeInsets.only(
                    bottom: screenHeight * (AppTheme.filterTabsBottomPaddingPercent + AppTheme.filterTabsHeightPercent),
                  ),
                  itemCount: state.savedEventsInfo.length,
                  itemBuilder: (_, index) => EventsScreen.buildEventsListItem(
                    state.savedEventsInfo[index], 
                    true
                  )
                )
              );
              // return ListView.builder(
              //   key: PageStorageKey('SavedEvents!Initial'),
              //   padding: EdgeInsets.only(
              //     bottom: screenHeight * (AppTheme.filterTabsBottomPaddingPercent + AppTheme.filterTabsHeightPercent),
              //   ),
              //   itemCount: state.savedEventsInfo.length,
              //   itemBuilder: (_, index) => EventsScreen.buildEventsListItem(
              //     state.savedEventsInfo[index], 
              //     true
              //   )
              // );
            }
          } else if (state is InSavedEventsScreen) {
            print("SAVED EVENTS SCREEN LENGTH: ");
            print(state.savedEventsInfo.length);
            if (state.savedEventsInfo.length == 0) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_dissatisfied,
                        color: Theme.of(context).accentColor,
                        size : 40.0
                      ),
                      SizedBox(
                        height: 15.0
                      ),
                      AutoSizeText(
                        "You have not yet favorited an event!",
                        maxLines: 2,
                        maxFontSize: AppTheme.cardDescriptionTextSize.max,
                        minFontSize: AppTheme.cardDescriptionTextSize.min,
                        style: Theme.of(context).textTheme.caption
                      )
                    ],
                  )
                )
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor
                ),
                child: ListView.builder(
                  key: PageStorageKey('SavedEvents!AddingOrDeleting'),
                  padding: EdgeInsets.only(
                    bottom: screenHeight * (AppTheme.filterTabsBottomPaddingPercent + AppTheme.filterTabsHeightPercent),
                  ),
                  itemCount: state.savedEventsInfo.length,
                  itemBuilder: (_, index) => EventsScreen.buildEventsListItem(
                    state.savedEventsInfo[index], 
                    !state.toDeleteMap.containsKey(state.savedEventsInfo[index].documentId)
                  )
                )
              );
            }
          }
          return buildLoadingSavedEvents();
        },
      ),
      onNotification: (scrollNotification) {
        eventsScrollBloc.add(ScrollPositionChanged(scrollNotification.metrics.pixels));
      },
    );
  }
}

