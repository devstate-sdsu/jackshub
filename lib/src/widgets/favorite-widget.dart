import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/data/blocs/bloc_provider.dart';
import 'package:jackshub/data/blocs/saved_events_bloc.dart';
import '../../data/database_helpers.dart';
import '../../data/models/saved_event_model.dart';

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

_save(String documentId) async {
  SavedEvent newSavedEvent = SavedEvent(documentId);
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
  final SavedEventBloc savedEventBloc;

  FavoriteWidget({Key key, this.docId, this.savedEventBloc}): super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {

  void _favEvent() {
    widget.savedEventBloc.inAddSavedEvent.add(SavedEvent(widget.docId));
  }

  bool _isFavorited = false;
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
        _read();
        _delete(widget.docId);
      } else {
        _isFavorited = true;
        _favEvent();
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
