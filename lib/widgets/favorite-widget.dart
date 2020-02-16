import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_event.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_state.dart';
import 'package:jackshub/util/database_helpers.dart';

class FavoriteWidget extends StatelessWidget {
  final EventInfo event;
  final bool isFav;

  FavoriteWidget({this.event, this.isFav});

  @override
  Widget build(BuildContext context) {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);

    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsInfoLoadedFromLocal || state is InSavedEventsScreen) {
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.all(0.0),
              alignment: Alignment.center,
              icon: this.isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              iconSize: 24.0,
              color: Colors.red,
              onPressed: () {
                if (state is InSavedEventsScreen) {
                  if (this.isFav) {
                    savedEventsBloc.add(DeleteSavedEventWithoutRefresh(documentId: this.event.documentId));
                  } else {
                    savedEventsBloc.add(AddSavedEventWithoutRefresh(eventInfo: this.event));
                  }
                } else if (state is SavedEventsInfoLoadedFromLocal) {
                  if (this.isFav) {
                    savedEventsBloc.add(DeleteSavedEvent(documentId: this.event.documentId));
                  } else {
                    savedEventsBloc.add(AddSavedEvent(eventInfo: this.event));
                  }
                }
              }
            ); 
        }
        return IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.center,
          icon: Icon(Icons.favorite_border),
          iconSize: 24.0,
          color: Colors.grey,
          onPressed: () {},
        ); 
      },
    );
  }
}
