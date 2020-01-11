import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'favorite-widget.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/widgets/index.dart';


class EventsCard extends StatelessWidget {
  EventsCard({
    this.name,
    this.summary,
    this.description,
    this.img,
    this.tinyLocation,
    this.bigLocation,
    this.coords,
    this.startTime,
    this.endTime,
    this.timeUpdated,
    this.favorite,
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
  final Timestamp startTime;
  final Timestamp endTime;
  final dynamic coords;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - (AppTheme.cardSideMargin * 2);
    double cardHeight = cardWidth * 1.25;

    String dateString = new DateFormat.MMMd().format(this.startTime.toDate());
    String startString = new DateFormat.jm().format(this.startTime.toDate());
    String endString = new DateFormat.jm().format(this.endTime.toDate());

    // DateTime start = DateTime.fromMillisecondsSinceEpoch(this.startTime.seconds * 1000);
    // DateTime end = DateTime.fromMillisecondsSinceEpoch(this.endTime.seconds * 1000);

    // String dateString = new DateFormat.MMMd().format(start);
    // String startString = new DateFormat.jm().format(start);
    // String endString = new DateFormat.jm().format(end);

    return Center(
        child: Container(
          height: cardHeight,
          margin: EdgeInsets.symmetric(
            horizontal: AppTheme.cardSideMargin,
            vertical: AppTheme.cardVerticalMargin
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: NetworkImage(
                  this.img
                ),
              ),
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              boxShadow: [
                BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: AppTheme.shadowBlurRadius,
                    offset: AppTheme.shadowOffset
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
                      topLeft: Radius.circular(AppTheme.cardRadius),
                      topRight: Radius.circular(AppTheme.cardRadius)
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
                      bottomLeft: Radius.circular(AppTheme.cardRadius),
                      bottomRight: Radius.circular(AppTheme.cardRadius)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor
                    ),
                    height: cardHeight * 0.382,
                    child: SizedBox(
                      width: double.infinity,
                      child: FractionallySizedBox(
                        widthFactor: 0.92,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 10.0),
                          child: Column(  // The whole bottom block of an events card
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Column(
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
                                    AutoSizeText(
                                      this.description,
                                      textAlign: TextAlign.left,
                                      maxLines: 3,
                                      minFontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Row( // Bottom block that has location, date, time
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: locationComponent(context, this.bigLocation, this.tinyLocation)
                                      /*child: Row(  // Location block
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
                                                  maxLines: 2,
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
                                      ),*/
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(  // Date and time blocks
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Flexible(
                                            child: dateComponent(context, dateString)
                                            /*child: Row(  // Date block
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
                                            ),*/
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: timeComponent(context, startString, endString)
                                            /*child: Row(  // Time block
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
                                            ),*/
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: FavoriteWidget(
                                        docId: this.docId,
                                        isFav: this.favorite,
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
