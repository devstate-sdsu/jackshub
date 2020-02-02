import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/screens/events.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/util/database_helpers.dart';
import 'package:jackshub/widgets/ColorLoader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_state.dart';

Widget buildLoadingSavedEvents() {
  return Container(
    child: ColorLoader5(),
    // child: Text(
    //   "Loading..."
    // ),
  );
}

class SavedEvents extends StatefulWidget {
 // final List<DocumentSnapshot> savedEvents;

  const SavedEvents({Key key}): super(key: key);

  @override
  _SavedEventsState createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {  
  List<SavedEvent> eventsList = new List<SavedEvent>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if(state is SavedEventsInfoLoaded) {
          return ListView.builder(
            itemCount: state.savedEventsInfo.length,
            itemBuilder: (_, index) => EventsScreen.buildEventsListItem(
              state.savedEventsInfo[index], 
              true
            )
          );
        }
        return buildLoadingSavedEvents();
      },
    );
  }
}

