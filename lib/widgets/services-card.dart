import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/config/router.dart';
import 'package:jackshub/config/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jackshub/util/date-time-helper.dart';


class ServicesCard extends StatefulWidget {
  final DocumentSnapshot doc;
  final String name;
  final String image;
  final String summary;
  final String mainInfo;
  final String bigLocation;
  final String littleLocation;
  final String email;
  final String phoneNumber;
  final ServiceHours serviceHours;

  const ServicesCard({
    Key key,
    this.doc,
    this.name,
    this.image,
    this.summary,
    this.mainInfo,
    this.bigLocation,
    this.littleLocation,
    this.email,
    this.phoneNumber,
    this.serviceHours
  }): super(key: key);

  @override
  _ServicesCard createState() => _ServicesCard();
}



class _ServicesCard extends State<ServicesCard> with TickerProviderStateMixin {
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
              '/detailedServices',
              arguments: ServicesRoutingParameters(
                widget.doc,
                widget.name,
                widget.image,
                widget.mainInfo,
                widget.bigLocation,
                widget.littleLocation,
                widget.email,
                widget.phoneNumber,
                widget.serviceHours
              ),
            );
          },
          onTapCancel: () {
            _controller.reverse();
          },
          child: Transform.scale(
            scale: _animation.value,
            child: Container(
              height: AppTheme.cardServicesHeight,
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
                      tag: 'servicesCardImg'+widget.doc.documentID,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.cardRadius),
                          bottomLeft: Radius.circular(AppTheme.cardRadius)
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )
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
                    )
                  ),
                  SizedBox(
                    width: 15
                  ),
                  Expanded(
                    flex: 725,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5
                        ),
                        Flexible(
                          flex: 20,
                          child: AutoSizeText(
                            widget.name,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            maxFontSize: AppTheme.cardSmallEventsTitleTextSize.max,
                            minFontSize: AppTheme.cardSmallEventsTitleTextSize.min,
                            style: Theme.of(context).textTheme.title
                          )
                        ),
                        Spacer(
                          flex: 2
                        ),
                        Flexible(
                          flex: 25,
                          child: AutoSizeText(
                            widget.summary,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            maxFontSize: AppTheme.cardDescriptionTextSize.max,
                            minFontSize: AppTheme.cardDescriptionTextSize.min,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                        SizedBox(
                          height: 10
                        ),
                        currentServiceStatus(context, widget.serviceHours),
                        /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lens,
                              size: 10.0,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 1
                            ),
                            Expanded(
                              flex: 1,
                              child: currentServiceStatus(context, widget.serviceHours)
                              // child: AutoSizeText(
                              //   "Currently open until 4:00pm",
                              //   maxLines: 1,
                              //   textAlign: TextAlign.left,
                              //   maxFontSize: AppTheme.cardDescriptionTextSize.max,
                              //   minFontSize: AppTheme.cardDescriptionTextSize.min,
                              //   style: TextStyle(
                              //     color: Colors.green,
                              //     fontWeight: FontWeight.w700,
                              //     fontFamily: 'Roboto'
                              //   )
                              // )
                            ),
                          ],
                        ),
                        */
                        /*Text(
                          widget.status,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption
                        ),*/
                        SizedBox(
                          height: 7
                        )
                      ],
                    )
                  ),
                  SizedBox(
                    width: 10
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
 