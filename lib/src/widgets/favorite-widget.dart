import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_event.dart';
import '../../database_helpers.dart';

_read() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  int docId = 1;
  SavedEvent savedEvent = await helper.querySavedEvent();
  if (savedEvent == null) {
    print('read row $docId: empty');
  } else {
    print('read row $docId: ${savedEvent.documentId}');
  }
}

Future<void> _save(String documentId) async {
  SavedEvent newSavedEvent = SavedEvent();
  newSavedEvent.documentId = documentId;
  DatabaseHelper helper = DatabaseHelper.instance;
  int id = await helper.insert(newSavedEvent);
  print('inserted row: $id');
}

_delete(String documentId) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.delete(documentId);
}

class FavoriteWidget extends StatefulWidget {
  final String docId;

  const FavoriteWidget({Key key, this.docId}): super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);
    setState(() {
      if (_isFavorited) {
        this._favoriteCount -= 1;
        this._isFavorited = false;
        _read();
        _delete(widget.docId);
      } else {
        this._favoriteCount += 1;
        this._isFavorited = true;
        _save(widget.docId).then((voidFuture) {
          savedEventsBloc.add(GetSavedEvents());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
          icon: (_isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
          color: Colors.red,
          onPressed: _toggleFavorite,
        );
  }
}
