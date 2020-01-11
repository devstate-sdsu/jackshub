import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/widgets/index.dart';


class EventsSmallCard extends StatefulWidget {
  final String name;
  final String image;
  final String bigLocation;
  final String littleLocation;
  final Timestamp startTime;
  final Timestamp endTime;
  final bool favorite;
  final String docId;

  const EventsSmallCard({
    Key key,
    this.name,
    this.image,
    this.bigLocation,
    this.littleLocation,
    this.startTime,
    this.endTime,
    this.favorite,
    this.docId,
  });

  @override
  _EventsSmallCard createState() => _EventsSmallCard();
}

class _EventsSmallCard extends State<EventsSmallCard> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  double cardVerticalSize = 135.0;

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

    DateTime start = DateTime.fromMillisecondsSinceEpoch(widget.startTime.seconds * 1000);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(widget.endTime.seconds * 1000);

    String dateString = new DateFormat.MMMd().format(start);
    String startString = new DateFormat.jm().format(start);
    String endString = new DateFormat.jm().format(end);


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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 350,
                    child: Hero(
                      tag: 'eventsSmallCardImg'+widget.docId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.cardRadius),
                          bottomLeft: Radius.circular(AppTheme.cardRadius),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
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
                    flex: 40
                  ),
                  Expanded(
                    flex: 725,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0
                        ),
                        Hero(
                          tag: 'eventsSmallCardTitle'+widget.docId,
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.title
                          )
                        ),
                        SizedBox(
                          height: 10.0
                        ),
                        Expanded(
                          child: locationComponent(context, widget.bigLocation, widget.littleLocation),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                child: dateComponent(context, dateString),
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
