import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'favorite-widget.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/widgets/index.dart';



class EventsCard extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final String summary;
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
    this.summary,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double cardVerticalSize = screenWidth - (AppTheme.cardSideMargin*2) - 15;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return GestureDetector(

          onTapDown: (TapDownDetails details) {
            _controller.forward();
          },

          onTapUp: (TapUpDetails details) {
            _controller.reverse();
            // PushNamed route!
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 400,
                    child: Hero(
                      tag: 'eventsCardImg'+widget.docId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.cardRadius),
                          topRight: Radius.circular(AppTheme.cardRadius),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.image
                              )
                            )
                          )
                        )
                      )
                    )
                  ),
                  Spacer(
                    flex: 10
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3
                      ),
                      Expanded(
                        flex: 100,
                        child: Hero(
                          tag: 'eventsCardTitle'+widget.docId,
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.title
                          )
                        )
                      ),
                      Spacer(
                        flex: 3
                      )
                    ]
                  ),
                  Spacer(
                    flex: 5
                  ),
                  Flexible(
                    flex: 100,
                    child: Row(
                      children: <Widget>[
                        Spacer(
                          flex: 3
                        ),
                        Expanded(
                          flex: 100,
                          child: Text(
                            widget.description,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Spacer(
                          flex: 3
                        )
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 10
                  ),
                  Flexible(
                    flex: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: locationComponent(context, widget.bigLocation, widget.littleLocation)
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                child: dateComponent(context, dateString)
                              ),
                              Flexible(
                                child: timeComponent(context, startString, endString)
                              )
                            ],
                          )
                        )
                      ],
                    )
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
