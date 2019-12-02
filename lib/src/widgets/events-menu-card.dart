import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    this.docId
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
                      height: this.height *.618,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)
                    ),
                    child: Container(
                      height: this.height * 0.382,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.89,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: AutoSizeText(
                                                this.name,
                                                textAlign: TextAlign.left,
                                                minFontSize: 20,
                                                style: TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                            AutoSizeText(
                                              this.summary,
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              minFontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: double.infinity,
                                //   child: FractionallySizedBox(
                                //     widthFactor: 0.89,
                                //     child: Padding(
                                //       padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
                                //       child: AutoSizeText(
                                //         this.summary,
                                //         textAlign: TextAlign.left,
                                //         maxLines: 2,
                                //         minFontSize: 13,
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   child: Padding(
                                //     padding: EdgeInsets.all(5.0),
                                //     child: FavoriteWidget(
                                //       docId: docId,
                                //     ),
                                //   ),
                                // ),
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
