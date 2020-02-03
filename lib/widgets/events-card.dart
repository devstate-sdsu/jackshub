import 'package:flutter/material.dart';

import 'package:jackshub/config/router.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/widgets/index.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';



class EventsCard extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final String bigLocation;
  final String littleLocation;
  final Timestamp startTime;
  final Timestamp endTime;
  final bool favorite;
  final String docId;

  const EventsCard({
    Key key,
    this.name,
    this.image,
    this.description,
    this.bigLocation,
    this.littleLocation,
    this.startTime,
    this.endTime,
    this.favorite,
    this.docId,
  });

  @override
  _EventsCard createState() => _EventsCard();
}



class _EventsCard extends State<EventsCard> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  var cardScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: AppTheme.cardAnimateDuration
      )
    );
    _animation = Tween(
      begin: 1.0,
      end: AppTheme.cardTouchedScale
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.cardForwardCurve,
        reverseCurve: AppTheme.cardReverseCurve
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
    String dateString = new DateFormat.MMMd().format(widget.startTime.toDate());
    String startString = new DateFormat.jm().format(widget.startTime.toDate());
    String endString = new DateFormat.jm().format(widget.endTime.toDate());
    double cardVerticalSize = AppTheme.cardLargeEventsHeight;

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
                widget.docId,
                widget.name,
                widget.image,
                widget.description, // description
                widget.bigLocation,
                widget.littleLocation,
                widget.startTime,
                widget.endTime,
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
                    color: AppTheme.shadowColor,
                    blurRadius: AppTheme.shadowBlurRadius,
                    offset: AppTheme.shadowOffset
                  )
                ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 600,
                    child: Hero(
                      tag: 'eventsCardImg'+widget.docId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.cardRadius),
                          topRight: Radius.circular(AppTheme.cardRadius),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider, 
                                fit: BoxFit.cover
                              ),
                            )
                          ),
                          placeholder: (context, url) => Image(
                            image: AssetImage('assets/images/loadingPlaceHolder.png')
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 30.0
                          ),
                        )
                        
                        /*Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              alignment: Alignment.topCenter,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.image
                              )
                            )
                          )
                        )*/
                      )
                    )
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Expanded(
                    flex: 400,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 12
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: 'eventsCardTitle'+widget.docId,
                                child: AutoSizeText(
                                  widget.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  maxFontSize: AppTheme.cardLargeEventsTitleTextSize.max,
                                  minFontSize: AppTheme.cardLargeEventsTitleTextSize.min,
                                  style: Theme.of(context).textTheme.title,
                                  overflow: TextOverflow.ellipsis
                                )
                              ),
                              Spacer(
                                flex: 10
                              ),
                              AutoSizeText(
                                widget.description,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                maxFontSize: AppTheme.cardDescriptionTextSize.max,
                                minFontSize: AppTheme.cardDescriptionTextSize.min,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(
                                flex: 10
                              ),
                              Flexible(
                                flex: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 50,
                                      child: timeComponent(context, startString, endString)
                                    ),
                                    Spacer(
                                      flex: 5
                                    ),
                                    Flexible(
                                      flex: 50,
                                      child: dateComponent(context, dateString)
                                    )
                                  ],
                                )
                              ),
                              Spacer(
                                flex: 5
                              ),
                              Flexible(
                                flex: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 20,
                                      child: locationComponent(context, widget.bigLocation, widget.littleLocation)
                                    ),
                                    Spacer(
                                      flex: 1
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: FavoriteWidget(
                                        docId: widget.docId,
                                        isFav: widget.favorite
                                      )
                                    )
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 12
                        )
                      ],
                    )
                  ),
                  SizedBox(
                    height: 10
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
