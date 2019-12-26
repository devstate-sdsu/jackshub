import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';



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
    DocumentSnapshot snapshot;
    await Firestore.instance.collection('foodCol').document(docId).get().then((DocumentSnapshot docsnap) {
      snapshot = docsnap;
    });
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSnapshot(docId),
      builder: (context, snapshot) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: <Widget>[
              Image(
                //alignment: Alignment.topRight,
                image: NetworkImage(snapshot.data["image"]),
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
                        child: Text(
                          snapshot.data["name"],
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.title,
                        )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: cardSidePadding,
                      right: cardSidePadding, 
                    ),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: shadowBlurRadius,
                          offset: shadowOffset,
                        )
                      ],
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          snapshot.data["description"][0],
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          snapshot.data["description"][1],
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    )
                  )
                ],
              )
            ]
          )
        );
      }
    );
  }
}

