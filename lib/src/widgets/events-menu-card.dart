import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'favorite-widget.dart';


class EventsMenuCard extends StatelessWidget {
  EventsMenuCard({
    this.name,
    this.summary,
    this.description,
    this.img,
    this.tinyLocation,
    this.bigLocation,
    this.coords,
    this.time,
    this.timeUpdated,
    this.favorite = false,
    this.docId
  });

  final String name;
  final String description;
  final String summary;
  final String tinyLocation;
  final String bigLocation;
  final String img;
  final String docId;
  final dynamic timeUpdated;
  final List<dynamic> time;
  final dynamic coords;
  bool favorite;

  @override
  Widget build(BuildContext context) {
    double cardPadding = 20.0;
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - (cardPadding * 2);
    double cardHeight = cardWidth * 1.1;
    double cardBorderRadius = 15;

    DateTime start = DateTime.fromMillisecondsSinceEpoch(this.time[0].seconds * 1000);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(this.time[1].seconds * 1000);

    String dateString = new DateFormat.MMMd().format(start);
    String startString = new DateFormat.jm().format(start);
    String endString = new DateFormat.jm().format(end);

    return Center(
        child: Container(
          height: cardHeight,
          margin: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: NetworkImage(
                  this.img
                ),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(cardBorderRadius),
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
              Expanded(
                flex: 618,   // Golden ratio
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cardBorderRadius),
                      topRight: Radius.circular(cardBorderRadius)
                  ),
                  child: Image(
                    image: Image.network(this.img).image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Expanded(
                flex: 382,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(cardBorderRadius),
                      bottomRight: Radius.circular(cardBorderRadius)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    height: cardHeight * 0.382,
                    child: SizedBox(
                      width: double.infinity,
                      child: FractionallySizedBox(
                        widthFactor: 0.89,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                          child: Column(  // The whole bottom block of an events card
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              Flexible(
                                child: AutoSizeText(
                                  this.summary,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  minFontSize: 13,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: Row( // Bottom block that has location, date, time
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(  // Location block
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xFF747474)
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  this.bigLocation,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'SF Pro',
                                                    fontSize : 13,
                                                    color: Color(0xFF747474),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: this.tinyLocation != "",
                                                  child: Text(
                                                    this.tinyLocation,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontFamily: 'SF Pro',
                                                      color: Color(0xFF747474),
                                                      fontSize : 12
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                        child: Column(  // Date and time blocks
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Flexible(
                                              child: Row(  // Date block
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                                                    child: Icon(
                                                      Icons.calendar_today,
                                                      size: 13,
                                                      color: Color(0xFF747474)
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    dateString,
                                                    maxFontSize: 12,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'SF Pro',
                                                      color: Color(0xFF747474),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Row(  // Time block
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                                                    child: Icon(
                                                      Icons.schedule,
                                                      size: 13,
                                                      color: Color(0xFF747474)
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: AutoSizeText(
                                                      startString + "-" + endString,
                                                      maxFontSize: 12,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'SF Pro',
                                                        color: Color(0xFF747474),
                                                      ),
                                                    ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),);
  }
}
