import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jackshub/data/blocs/bloc_provider.dart';
import 'package:jackshub/data/blocs/saved_events_bloc.dart';
import 'favorite-widget.dart';


class EventsMenuCard extends StatelessWidget {
  EventsMenuCard({
    this.name,
    this.summary,
    this.description,
    this.img,
    this.height = 360,
    this.location,
    this.coords,
    this.time,
    this.timeUpdated,
    this.favorite = false,
    this.docId,
    this.savedEventBloc
  });

  final String name;
  final String description;
  final String summary;
  final String location;
  final String img;
  final String docId;
  final dynamic timeUpdated;
  final List<dynamic> time;
  final dynamic coords;
  final double height;
  bool favorite;
  final SavedEventBloc savedEventBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 50,
                        offset: Offset(0, 5)
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)
                    ),
                    child: Image(
                      image: Image.network(this.img).image,
                      fit: BoxFit.fitWidth,
                      height: this.height *.8,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)
                    ),
                    child: Container(
                      height: this.height * 0.2,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: AutoSizeText(
                                    this.name,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Hobo',
                                      fontSize: 35,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                        child: AutoSizeText(
                                          this.summary,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          minFontSize: 15,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: BlocProvider(
                                        bloc: SavedEventBloc(),
                                        child: FavoriteWidget(
                                          docId: docId,
                                          savedEventBloc: savedEventBloc,
                                        ),
                                      ),                                  
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),);
  }
}
