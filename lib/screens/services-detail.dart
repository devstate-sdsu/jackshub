import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
//import 'package:jackshub/util/database_helpers.dart';



class DetailedServicesScreen extends StatelessWidget {
  DetailedServicesScreen({
    this.docId,
  });

  final String docId;

  final double cardBorderRadius = 15.0;
  final double cardSidePadding = 20.0;
  
  final Color shadowColor = Color.fromRGBO(0,0,0,0.25);
  final double shadowBlurRadius = 20.0;
  final Offset shadowOffset = Offset(0,5);


  Future<DocumentSnapshot> _getSnapshot(String docId) async {
    DocumentSnapshot snapshot = await Firestore.instance.collection('foodCol').document(docId).get();
    /*DocumentSnapshot snapshot;
    await Firestore.instance.collection('foodCol').document(docId).get().then((DocumentSnapshot docsnap) {
      snapshot = docsnap;
    });*/
    return snapshot;
  }

//PAGE cardBase + DOC ID
//flutter: cardBaseK01IOcyPu187rq4QgdUc

//flutter: CARD cardBase + WIDGET DOC ID
//flutter: cardBaseK01IOcyPu187rq4QgdUc


/*

  TODO:

  Transition the card to the screen.
  FutureBuilder load the card on the screen, not the entire screen itself.

*/



  @override
  Widget build(BuildContext context) {

    print("PAGE cardBase + DOC ID ");
    print('cardBase'+docId);

    return FutureBuilder(
      future: _getSnapshot(this.docId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Stack(
              children: <Widget>[
                Image(
                  alignment: Alignment.topRight,
                  image: NetworkImage(snapshot.data["img"]),
                  fit: BoxFit.fitWidth,
                ),
                ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print(" ON TAP GESTURE ");
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 400,
                        color: Colors.transparent,
                      )
                    ),
                    Row(
                      children: <Widget>[
                        Spacer(
                          flex: 100
                        ),
                        Expanded(
                          flex: 1000,
                          //child: Hero(
                            //tag: 'cardTitle'+docId,
                            child: Text(
                              snapshot.data["name"],
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.title,
                            )
                          //)
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25
                    ),
                    Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'cardBase'+docId,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              left: cardSidePadding,
                              right: cardSidePadding
                            ),
                            color: Theme.of(context).cardColor,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20
                                ),
                                Text(
                                  snapshot.data["description"][0],
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  height: 20
                                ),
                                Text(
                                  snapshot.data["description"][1],
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  height: 20
                                ),
                                Text(
                                  snapshot.data["description"][2],
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          )
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Sorry, something went wrong!'));
        } else {
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              width: 50,
              height: 50
            )
          );
        }
      }
    );
  }
}