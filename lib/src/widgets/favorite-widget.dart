import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_event.dart';
import 'package:jackshub/src/bloc/saved_events_state.dart';
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

Future<void> _delete(String documentId) async {
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
  bool isFav = false;
  Map docIdSet;
  void _favorite() {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);
    _save(widget.docId).then((_) {
      savedEventsBloc.add(GetSavedEvents());
    });
  }

  void _unfavorite() {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);
    _delete(widget.docId).then((_) {
      savedEventsBloc.add(GetSavedEvents());
    });
  }

  @override
  Widget build(BuildContext context) {
    // return IconButton(
    //       icon: (_isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
    //       color: Colors.red,
    //       onPressed: _toggleFavorite,
    //     );
    return BlocListener<SavedEventsBloc, SavedEventsState>(
      listener: (context, state) {
        if (state is SavedEventsLoaded) {
          docIdSet = Map.fromIterable(state.savedEvents, key: (savedEvent) => savedEvent.documentID, value: (savedEvent) => true);
          if (docIdSet.containsKey(widget.docId)) {
            this.isFav = true;
          } else {
            this.isFav = false;
          }
        } 
      },
      child: BlocBuilder<SavedEventsBloc, SavedEventsState>(
        builder: (context, state) {
          if (state is SavedEventsLoaded) {
              return IconButton(
                icon: this.isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                color: this.isFav ? Colors.red : Colors.grey,
                onPressed: this.isFav ? _unfavorite : _favorite,
              ); 
          }
          return IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.grey,
            onPressed: _favorite,
          ); 
        },
      ),
    );
  }
}
