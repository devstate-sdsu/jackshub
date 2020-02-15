import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/globals/globals.dart';
import 'package:jackshub/screens/events.dart';
import 'package:jackshub/src/blocs/events_scroll/events_scroll_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_bloc.dart';
import 'package:jackshub/util/database_helpers.dart';
import 'package:jackshub/widgets/ColorLoader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_state.dart';

Widget buildLoadingSavedEvents() {
  return Container(
    child: ColorLoader5(),
  );
}

class SavedEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventsScrollBloc eventsScrollBloc = BlocProvider.of<EventsScrollBloc>(context);
    return NotificationListener(
      child: BlocBuilder<SavedEventsBloc, SavedEventsState>(
        builder: (context, state) {
          if(state is SavedEventsInfoLoaded) {
            return ListView.builder(
              padding: EdgeInsets.only(
                bottom: AVOID_FILTER_TABS_HEIGHT
              ),
              itemCount: state.savedEventsInfo.length,
              itemBuilder: (_, index) => EventsScreen.buildEventsListItem(
                state.savedEventsInfo[index], 
                true
              )
            );
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

