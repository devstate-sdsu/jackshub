import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jackshub/config/router.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/util/database_helpers.dart';
import 'package:jackshub/widgets/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';



class EventsSmallCard extends StatefulWidget {
  final EventInfo event;
  final bool favorite;

  const EventsSmallCard({
    Key key,
    this.event,
    this.favorite
  });

  @override
  _EventsSmallCard createState() => _EventsSmallCard();
}



class _EventsSmallCard extends State<EventsSmallCard> with TickerProviderStateMixin {
  String name;
  String image;
  String bigLocation;
  String littleLocation;
  Timestamp startTime;
  Timestamp endTime;
  bool favorite;
  
  AnimationController _controller;
  Animation _animation;
  double cardVerticalSize = AppTheme.cardSmallEventsHeight;
  double locationIconOffset = 2.0;
  int tinyLocationOffset = 40;
  var cardScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: AppTheme.cardAnimateDuration,
      )
    );
    _animation = Tween(
      begin: 1.0,
      end: AppTheme.cardTouchedScale
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.cardForwardCurve,
        reverseCurve: AppTheme.cardReverseCurve,
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dateString = new DateFormat.MMMEd().format(widget.event.startTime.toDate().toUtc());
    String startString = new DateFormat.jm().format(widget.event.startTime.toDate().toUtc());
    String endString = new DateFormat.jm().format(widget.event.endTime.toDate().toUtc());

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return GestureDetector(

          onTapDown: (TapDownDetails details) {
            _controller.forward();
          },

          onTapUp: (TapUpDetails details) {
            _controller.reverse();
            Navigator.pushNamed(
              context,
              '/detailedEvents',
              arguments: EventsRoutingParameters(
                event: widget.event,
                blocContext: context
              )
            );
          },

          onTapCancel: () {
            _controller.reverse();
          },

          child: Transform.scale(
            scale: _animation.value,
            child: Container(
              height: cardVerticalSize,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: AppTheme.cardSideMargin,
                vertical: AppTheme.cardVerticalMargin
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: (Theme.of(context).brightness == Brightness.light) ? AppTheme.lightShadowColor: AppTheme.darkShadowColor,
                    blurRadius: AppTheme.shadowBlurRadius,
                    offset: AppTheme.shadowOffset
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 350,
                    child: Hero(
                      tag: 'eventsCardImg'+widget.event.documentId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.cardRadius),
                          bottomLeft: Radius.circular(AppTheme.cardRadius),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.event.image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider, 
                                fit: BoxFit.cover
                              ),
                            )
                          ),
                          placeholder: (context, url) => Container(
                            color: Colors.grey
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 30.0
                          ),
                        )
                      )

                        /*
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetw(
                                widget.event.image
                              )
                            )
                          )
                        )
                      )
                      */
                    )
                  ),
                  Spacer(
                    flex: 40
                  ),
                  Expanded(
                    flex: 725,
                    child: Column(
                      //physics: NeverScrollableScrollPhysics(),
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 8
                        ),
                        Expanded(
                          flex: widget.event.tinyLocation.isEmpty ? 100 : 100 - tinyLocationOffset,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: locationIconOffset
                              ),
                              Expanded(
                                flex: 150,
                                child: Hero(
                                  tag: 'eventsCardTitle'+widget.event.documentId,
                                    child: AutoSizeText(    // Card title
                                      widget.event.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      maxFontSize: AppTheme.cardSmallEventsTitleTextSize.max,
                                      minFontSize: AppTheme.cardSmallEventsTitleTextSize.min,
                                      style: Theme.of(context).textTheme.title
                                    )
                                ),
                              )
                            ],
                          )
                        ),
                        Visibility(
                          visible: widget.event.tinyLocation.isEmpty,
                          child: Spacer(
                            flex: 10
                          ),
                        ),
                        Expanded(
                          flex: widget.event.tinyLocation.isEmpty ? 30 : 30 + tinyLocationOffset,
                          child: locationComponent(context, widget.event.bigLocation, widget.event.tinyLocation),
                        ),
                        Spacer(
                          flex: 10
                        ),
                        Expanded(
                          flex: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: locationIconOffset,
                              ),
                              Expanded(
                                flex: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 30,
                                      child: timeComponent(context, startString, endString)
                                    ),
                                    Spacer(
                                      flex: 4
                                    ),
                                    Expanded(
                                      flex: 30,
                                      child: dateComponent(context, dateString)
                                    ),
                                    Spacer(
                                      flex: 1
                                    )
                                  ],
                                )
                              ),
                              Expanded(
                                flex: 18,
                                child: FavoriteWidget(
                                  event: widget.event,
                                  isFav: widget.favorite
                                )
                              ),
                              Spacer(
                                flex: 1
                              )
                            ],
                          )
                        ),
                        SizedBox(
                          height: 9
                        )
                      ],
                    )
                  ),
                  Spacer(
                    flex: 40
                  )
                ],
              )
            )
          )
        );
      }
    );
  }
}