import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_bloc.dart';
import 'package:jackshub/src/bloc/saved_events_event.dart';
import 'package:jackshub/src/bloc/saved_events_state.dart';
import 'package:jackshub/util/database_helpers.dart';



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
  final bool isFav;

  const FavoriteWidget({Key key, this.docId, this.isFav}): super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  Map docIdSet;

  @override
  Widget build(BuildContext context) {
    final savedEventsBloc = BlocProvider.of<SavedEventsBloc>(context);

    void _favorite() {
      _save(widget.docId).then((_) {
        savedEventsBloc.add(GetSavedEvents());
      });
    }

    void _unfavorite() {
      _delete(widget.docId).then((_) {
        savedEventsBloc.add(GetSavedEvents());
      });
    }
  
    // return IconButton(
    //       icon: (_isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
    //       color: Colors.red,
    //       onPressed: _toggleFavorite,
    //     );
    // return BlocBuilder<SavedEventsBloc, SavedEventsState>(
    //     builder: (context, state) {
    //       print("State in Bloc Builder in Favorite Widget: ");
    //       print(state);
    //       if (state is SavedEventsLoaded) {
              return IconButton(
                icon: widget.isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                color: widget.isFav ? Colors.red : Colors.red,
                onPressed: widget.isFav ? _unfavorite : _favorite,
              ); 
          // }
          // return IconButton(
          //   icon: Icon(Icons.favorite_border),
          //   color: Colors.grey,
          //   onPressed: () {},
          // ); 
      //   },
      // );
  }
}
