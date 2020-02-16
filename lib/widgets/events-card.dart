import 'package:flutter/material.dart';

import 'package:jackshub/config/router.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/util/database_helpers.dart';
import 'package:jackshub/widgets/index.dart';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';



class EventsCard extends StatefulWidget {
  final EventInfo event;
  final bool favorite;

  const EventsCard({
    Key key,
    this.event,
    this.favorite,
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
    String dateString = new DateFormat.MMMd().format(widget.event.startTime.toDate());
    String startString = new DateFormat.jm().format(widget.event.startTime.toDate());
    String endString = new DateFormat.jm().format(widget.event.endTime.toDate());
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
                widget.event,
                context,
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
                      tag: 'eventsCardImg'+widget.event.documentId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.cardRadius),
                          topRight: Radius.circular(AppTheme.cardRadius),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.event.image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.topCenter,
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
                                widget.event.image
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
                                tag: 'eventsCardTitle'+widget.event.documentId,
                                child: AutoSizeText(
                                  widget.event.name,
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
                                widget.event.description,
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
                                      child: locationComponent(context, widget.event.bigLocation, widget.event.tinyLocation)
                                    ),
                                    Spacer(
                                      flex: 1
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: FavoriteWidget(
                                        event: widget.event,
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
