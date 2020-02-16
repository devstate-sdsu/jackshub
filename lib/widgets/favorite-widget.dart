import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_event.dart';
import 'package:jackshub/src/blocs/saved_events/saved_events_state.dart';
import 'package:jackshub/util/database_helpers.dart';



Future<void> _save(String documentId) async {
  SavedEventId newSavedEvent = SavedEventId();
  newSavedEvent.documentId = documentId;
  DatabaseHelper helper = DatabaseHelper.instance;
  int id = await helper.insertSavedEventId(newSavedEvent);
  print('inserted row: $id');
}



Future<void> _delete(String documentId) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.deleteSavedEventId(documentId);
}



class FavoriteWidget extends StatelessWidget {
  final EventInfo event;
  final bool isFav;

  const FavoriteWidget({this.event, this.isFav});

  @override
  Widget build(BuildContext context) {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);

    void _favorite() {
      savedEventsBloc.add(AddSavedEvent(eventInfo: this.event));
      // _save(this.event.documentId).then((_) {
      //   savedEventsBloc.add(AddSavedEvent(eventInfo: this.event));
      //   savedEventsBloc.add(GetSavedEventsInfo());
      // });
    }

    void _unfavorite() {
      savedEventsBloc.add(DeleteSavedEvent(documentId: this.event.documentId));
      // _delete(this.event.documentId).then((_) {
      //   savedEventsBloc.add(DeleteSavedEvent(documentId: this.event.documentId));
      //   savedEventsBloc.add(GetSavedEventsInfo());
      // });
    }
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsInfoLoadedFromLocal) {
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.all(0.0),
              alignment: Alignment.center,
              icon: this.isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              iconSize: 24.0,
              color: Colors.red,
              onPressed: this.isFav ? _unfavorite : _favorite,
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
