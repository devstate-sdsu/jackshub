import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_event.dart';
import 'package:jackshub/util/database_helpers.dart';


Future<void> _save(String documentId) async {
  SavedEvent newSavedEvent = SavedEvent();
  newSavedEvent.documentId = documentId;
  DatabaseHelper helper = DatabaseHelper.instance;
  int id = await helper.insert(newSavedEvent);
  print('inserted row: $id');
}

Future<void> _delete(String documentId) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.delete(documentId);
}

class FavoriteWidget extends StatelessWidget {
  final String docId;
  final bool isFav;

  const FavoriteWidget({this.docId, this.isFav});

  @override
  Widget build(BuildContext context) {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);

    void _favorite() {
      _save(this.docId).then((_) {
        savedEventsBloc.add(GetSavedEvents());
      });
    }

    void _unfavorite() {
      _delete(this.docId).then((_) {
        savedEventsBloc.add(GetSavedEvents());
      });
    }
  
    return IconButton(
      icon: this.isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      color: Colors.red,
      onPressed: this.isFav ? _unfavorite : _favorite,
    ); 
  }
}
