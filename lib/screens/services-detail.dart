import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/widgets/index.dart';



class DetailedServicesScreen extends StatelessWidget {
  DetailedServicesScreen({
    this.docId,
    this.name,
    this.image,
  });

  final String docId;
  final String name;
  final String image;

  final double cardBorderRadius = 15.0;
  final double cardSidePadding = 20.0;

  final Color shadowColor = Color.fromRGBO(0,0,0,0.25);
  final double shadowBlurRadius = 20.0;
  final Offset shadowOffset = Offset(0,5);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          )
        ),
        Hero(
          tag: 'servicesCardImg'+this.docId,
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  this.image
                )
              )
            )
          )
        ),
        ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.width - 150.0,
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
                  child: Hero(
                    tag: 'servicesCardTitle'+this.docId,
                    child: Text(
                      this.name,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline,
                    )
                  )
                )
              ],
            ),
            SizedBox(
              height: 25
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('servicesCol').document(this.docId).collection('cards').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => buildServicesInfoCards(context, snapshot.data.documents[index])
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: cardSidePadding,
                      right: cardSidePadding
                    ),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: shadowBlurRadius,
                          offset: shadowOffset
                        )
                      ]
                    ),
                    child: Text(
                      "Sorry, there has been an error! :(",
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.center
                    )
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.only(
                      left: cardSidePadding,
                      right: cardSidePadding
                    ),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: shadowBlurRadius,
                          offset: shadowOffset
                        )
                      ]
                    ),
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).indicatorColor)
                      )
                    )
                  );
                }
              }
            )
          ],
        )
      ],
    );
  }

  Widget buildServicesInfoCards(BuildContext context, DocumentSnapshot doc) {
    return ServicesDetailInfoCard(
      doc: doc
    );
  }
}