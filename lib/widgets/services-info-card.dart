import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ServicesDetailInfoCard extends StatelessWidget {
  ServicesDetailInfoCard({
    this.doc,
  });

  final DocumentSnapshot doc;

  final double cardBorderRadius = 15.0;
  final double cardSidePadding = 20.0;
  final double cardInnerPadding = 15.0;
  final double cardColumnSpacing = 10.0;

  final Color shadowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final double shadowBlurRadius = 20.0;
  final Offset shadowOffset = Offset(0, 5);

  Widget buildCard(BuildContext context, DocumentSnapshot doc) {
    if (doc['cardType'] == "mainInfo") {
      return Container(
        //margin: EdgeInsets.all(cardSidePadding),
        margin: EdgeInsets.only(
          bottom: cardSidePadding*2,
          left: cardSidePadding,
          right: cardSidePadding
        ),
        padding: EdgeInsets.all(cardInnerPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: shadowBlurRadius,
              offset: shadowOffset,
            )
          ]
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Phone Number: "+doc['phoneNumbers'],
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: cardColumnSpacing),
            Text(
              "Big Location: "+doc['bigLocation'],
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(height: cardColumnSpacing),
            Text(
              "Little Location: "+doc['littleLocation'],
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: cardColumnSpacing),
            Text(
              "Email: "+doc['email'],
              style: Theme.of(context).textTheme.caption
            ),
            SizedBox(height: cardColumnSpacing),
            buildHoursRow(context, "Monday", doc['regularHours']['monday']),
            buildHoursRow(context, "Tuesday", doc['regularHours']['tuesday']),
            buildHoursRow(context, "Wednesday", doc['regularHours']['wednesday']),
            buildHoursRow(context, "Thursday", doc['regularHours']['thursday']),
            buildHoursRow(context, "Friday", doc['regularHours']['friday']),
            buildHoursRow(context, "Saturday", doc['regularHours']['saturday']),
            buildHoursRow(context, "Sunday", doc['regularHours']['sunday']),
            SizedBox(height: cardColumnSpacing),
            Text(
              doc['title'],
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(height: cardColumnSpacing),
            Text(
              doc['mainInfo'],
              style: Theme.of(context).textTheme.caption,
            )
          ],
        )
      );
    } else if (doc['cardType'] == "regular") {
      return Container(
        margin: EdgeInsets.only(
          left: cardSidePadding,
          right: cardSidePadding,
          bottom: cardSidePadding*2,
        ),
        padding: EdgeInsets.all(cardInnerPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: shadowBlurRadius,
              offset: shadowOffset,
            )
          ]
        ),
        child: Column(
          children: <Widget>[
            Text(
              doc['title'],
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(height: cardColumnSpacing),
            Text(
              doc['contents'],
              style: Theme.of(context).textTheme.caption,
            )
          ],
        )
      );
    } else {
      return Container();
    }
  }

  Widget buildHoursRow(BuildContext context, String day, String hours) {
    return Row(
      children: <Widget>[
        Text(
          day,
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(
          child: Text(
            hours,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(context, this.doc);
  }
}

