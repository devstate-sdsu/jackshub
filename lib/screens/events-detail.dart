import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jackshub/src/blocs/saved_events/index.dart';
import 'package:jackshub/util/database_helpers.dart';

import 'package:jackshub/widgets/index.dart';
import 'package:jackshub/config/theme.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';



class DetailedEventsScreen extends StatefulWidget {
  final EventInfo event;
  final BuildContext blocContext;

  const DetailedEventsScreen({
    Key key,
    this.event,
    this.blocContext
  });

  @override
  _DetailedEventsScreen createState() => _DetailedEventsScreen();
}



class _DetailedEventsScreen extends State<DetailedEventsScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  var offset = -AppTheme.detailedScreenAnimateOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: AppTheme.detailedScreenAnimateDuration
      )
    );
    _animation = Tween(
      begin: -AppTheme.detailedScreenAnimateOffset,
      end: 0.0
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.detailedScreenCurve
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
    final SavedEventsBloc savedEventsBloc = BlocProvider.of<SavedEventsBloc>(widget.blocContext);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String dateString = new DateFormat.MMMEd().format(widget.event.startTime.toDate());
    String startString = new DateFormat.jm().format(widget.event.startTime.toDate());
    String endString = new DateFormat.jm().format(widget.event.endTime.toDate());
    _controller.forward();

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: <Widget>[
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              )
            ),
            Hero(
              tag: 'eventsCardImg'+widget.event.documentId,
              child: CachedNetworkImage(
                imageUrl: widget.event.image,
                imageBuilder: (context, imageProvider) => Container(
                  height: screenWidth,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )
                  )
                ),
                placeholder: (context, url) => Image(
                  image: AssetImage('lib/assets/images/loadingPlaceHolder.png')
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40.0
                  )
                )
              )
            ),
            Transform.translate(
              offset: Offset(0.0, -_animation.value),
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width*0.75,
                      color: Colors.transparent,
                    )
                  ),
                  /*Row(
                    children: <Widget>[
                      Spacer(
                        flex: 100
                      ),
                      Expanded(
                        flex: 1000,
                        child: Hero(
                          tag: 'eventsCardTitle'+this.docId,
                          child: AutoSizeText(
                            this.name,
                            textAlign: TextAlign.left,
                            maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                            minFontSize: Theme.of(context).textTheme.headline.fontSize,
                            style: Theme.of(context).textTheme.headline
                          )
                        )
                      )
                    ],
                  ),*/
                  /*SizedBox(
                    height: 20
                  ),*/
                  Container(
                    margin: EdgeInsets.only(
                      left: AppTheme.cardSideMargin,
                      right: AppTheme.cardSideMargin,
                      bottom: AppTheme.cardVerticalMargin
                    ),
                    padding: EdgeInsets.all(AppTheme.detailCardInnerPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
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
                      //mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: 'eventsCardTitleTEST'+widget.event.documentId,
                          child: AutoSizeText(
                            widget.event.name,
                            textAlign: TextAlign.left,
                            maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                            minFontSize: Theme.of(context).textTheme.headline.fontSize,
                            style: Theme.of(context).textTheme.headline
                          )
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Container(
                          height: 1.5,
                          color: Theme.of(context).accentColor
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 2
                            ),
                            Flexible(
                              flex: 10,
                              child: timeComponent(context, startString, endString)
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Flexible(
                              flex: 7,
                              child: dateComponent(context, dateString)
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10
                        ),
                        SizedBox(
                          height: 34,
                          child: locationComponent(context, widget.event.bigLocation, widget.event.tinyLocation)
                        ),
                        SizedBox(
                          height: 15
                        ),
                        Container(
                          height: 1.5,
                          color: Theme.of(context).accentColor
                        ),
                        SizedBox(
                          height: 10
                        ),
                        Visibility(
                          visible: widget.event.description != "",
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10
                              ),
                              Text(
                                widget.event.description,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.caption
                              ),
                              SizedBox(
                                height: 15
                              )
                            ],
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          color: Colors.white,
                          child: BlocProvider.value(
                            value: savedEventsBloc,
                            child: BlocBuilder(
                              bloc: savedEventsBloc,
                                builder: (context, state) {
                                  if (state is SavedEventsInfoLoadedFromLocal) {
                                    var ultimateDocIds = state.savedEventsIdsMap;
                                    return FavoriteWidget(event: widget.event, isFav: ultimateDocIds.containsKey(widget.event.documentId));
                                  } else if (state is InSavedEventsScreen) {
                                    return FavoriteWidget(event: widget.event, isFav: !state.toDeleteMap.containsKey(widget.event.documentId));
                                  } else {
                                    return FavoriteWidget(event: widget.event, isFav: false);
                                  }
                                }
                            )
                          ),
                        )
                      ],
                    )
                  )
                ]
              )
            ),
            /*
            ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width*0.7,
                    color: Colors.transparent,
                  )
                ),
                /*Row(
                  children: <Widget>[
                    Spacer(
                      flex: 100
                    ),
                    Expanded(
                      flex: 1000,
                      child: Hero(
                        tag: 'eventsCardTitle'+this.docId,
                        child: AutoSizeText(
                          this.name,
                          textAlign: TextAlign.left,
                          maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                          minFontSize: Theme.of(context).textTheme.headline.fontSize,
                          style: Theme.of(context).textTheme.headline
                        )
                      )
                    )
                  ],
                ),*/
                /*SizedBox(
                  height: 20
                ),*/
                Container(
                  margin: EdgeInsets.only(
                    left: AppTheme.cardSideMargin,
                    right: AppTheme.cardSideMargin,
                    bottom: AppTheme.cardVerticalMargin
                  ),
                  padding: EdgeInsets.all(AppTheme.detailCardInnerPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
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
                    //mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'eventsCardTitle'+widget.event.documentId,
                        child: AutoSizeText(
                          widget.event.name,
                          textAlign: TextAlign.left,
                          maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                          minFontSize: Theme.of(context).textTheme.headline.fontSize,
                          style: Theme.of(context).textTheme.headline
                        )
                      ),
                      SizedBox(
                        height: 15
                      ),
                      Container(
                        height: 1.5,
                        color: Theme.of(context).accentColor
                      ),
                      SizedBox(
                        height: 15
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 2
                          ),
                          Expanded(
                            flex: 10,
                            child: timeComponent(context, startString, endString)
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 5,
                            child: dateComponent(context, dateString)
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10
                      ),
                      SizedBox(
                        height: 30,
                        child: locationComponent(context, widget.event.bigLocation, widget.event.tinyLocation)
                      ),
                      SizedBox(
                        height: 15
                      ),
                      Container(
                        height: 1.5,
                        color: Theme.of(context).accentColor
                      ),
                      SizedBox(
                        height: 10
                      ),
                      Visibility(
                        visible: widget.event.description != "",
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10
                            ),
                            Text(
                              widget.event.description,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.caption
                            ),
                            SizedBox(
                              height: 10
                            )
                          ],
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        size: 24.0,
                        color: Colors.red
                      ),
                    ],
                  )
                )
              ]
            )
            */
          ],
          
        );
      }
    );

    /*
    return Stack(
      children: <Widget>[
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          )
        ),
        Hero(
          tag: 'eventsCardImg'+widget.event.documentId,
          child: CachedNetworkImage(
            imageUrl: widget.event.image,
            imageBuilder: (context, imageProvider) => Container(
              height: screenWidth,
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )
              )
            ),
            placeholder: (context, url) => Image(
              image: AssetImage('assets/images/loadingPlaceHolder.png')
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.red,
              size: 30.0
            )
          )
        ),
        Transform.translate(
          offset: Offset(0.0, _animation.value),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width*0.7,
                  color: Colors.transparent,
                )
              ),
              /*Row(
                children: <Widget>[
                  Spacer(
                    flex: 100
                  ),
                  Expanded(
                    flex: 1000,
                    child: Hero(
                      tag: 'eventsCardTitle'+this.docId,
                      child: AutoSizeText(
                        this.name,
                        textAlign: TextAlign.left,
                        maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                        minFontSize: Theme.of(context).textTheme.headline.fontSize,
                        style: Theme.of(context).textTheme.headline
                      )
                    )
                  )
                ],
              ),*/
              /*SizedBox(
                height: 20
              ),*/
              Container(
                margin: EdgeInsets.only(
                  left: AppTheme.cardSideMargin,
                  right: AppTheme.cardSideMargin,
                  bottom: AppTheme.cardVerticalMargin
                ),
                padding: EdgeInsets.all(AppTheme.detailCardInnerPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
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
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'eventsCardTitle'+widget.event.documentId,
                      child: AutoSizeText(
                        widget.event.name,
                        textAlign: TextAlign.left,
                        maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                        minFontSize: Theme.of(context).textTheme.headline.fontSize,
                        style: Theme.of(context).textTheme.headline
                      )
                    ),
                    SizedBox(
                      height: 15
                    ),
                    Container(
                      height: 1.5,
                      color: Theme.of(context).accentColor
                    ),
                    SizedBox(
                      height: 15
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 2
                        ),
                        Expanded(
                          flex: 10,
                          child: timeComponent(context, startString, endString)
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 5,
                          child: dateComponent(context, dateString)
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10
                    ),
                    SizedBox(
                      height: 30,
                      child: locationComponent(context, widget.event.bigLocation, widget.event.tinyLocation)
                    ),
                    SizedBox(
                      height: 15
                    ),
                    Container(
                      height: 1.5,
                      color: Theme.of(context).accentColor
                    ),
                    SizedBox(
                      height: 10
                    ),
                    Visibility(
                      visible: widget.event.description != "",
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10
                          ),
                          Text(
                            widget.event.description,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.caption
                          ),
                          SizedBox(
                            height: 10
                          )
                        ],
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      size: 24.0,
                      color: Colors.red
                    ),
                  ],
                )
              )
            ]
          )
        ),
        /*
        ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.width*0.7,
                color: Colors.transparent,
              )
            ),
            /*Row(
              children: <Widget>[
                Spacer(
                  flex: 100
                ),
                Expanded(
                  flex: 1000,
                  child: Hero(
                    tag: 'eventsCardTitle'+this.docId,
                    child: AutoSizeText(
                      this.name,
                      textAlign: TextAlign.left,
                      maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                      minFontSize: Theme.of(context).textTheme.headline.fontSize,
                      style: Theme.of(context).textTheme.headline
                    )
                  )
                )
              ],
            ),*/
            /*SizedBox(
              height: 20
            ),*/
            Container(
              margin: EdgeInsets.only(
                left: AppTheme.cardSideMargin,
                right: AppTheme.cardSideMargin,
                bottom: AppTheme.cardVerticalMargin
              ),
              padding: EdgeInsets.all(AppTheme.detailCardInnerPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
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
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'eventsCardTitle'+widget.event.documentId,
                    child: AutoSizeText(
                      widget.event.name,
                      textAlign: TextAlign.left,
                      maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                      minFontSize: Theme.of(context).textTheme.headline.fontSize,
                      style: Theme.of(context).textTheme.headline
                    )
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Container(
                    height: 1.5,
                    color: Theme.of(context).accentColor
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 2
                      ),
                      Expanded(
                        flex: 10,
                        child: timeComponent(context, startString, endString)
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 5,
                        child: dateComponent(context, dateString)
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10
                  ),
                  SizedBox(
                    height: 30,
                    child: locationComponent(context, widget.event.bigLocation, widget.event.tinyLocation)
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Container(
                    height: 1.5,
                    color: Theme.of(context).accentColor
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Visibility(
                    visible: widget.event.description != "",
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10
                        ),
                        Text(
                          widget.event.description,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption
                        ),
                        SizedBox(
                          height: 10
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.favorite_border,
                    size: 24.0,
                    color: Colors.red
                  ),
                ],
              )
            )
          ]
        )
        */
      ],
      
    );
    */
  }
}



/*
class DetailedEventsScreen extends StatelessWidget{
  DetailedEventsScreen({
    this.docId,
    this.name,
    this.image,
    this.description,
    this.bigLocation,
    this.tinyLocation,
    this.startTime,
    this.endTime,
  });

  final String docId;
  final String name;
  final String image;
  final String description;
  final String bigLocation;
  final String tinyLocation;
  final Timestamp startTime;
  final Timestamp endTime;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String dateString = new DateFormat.MMMd().format(this.startTime.toDate());
    String startString = new DateFormat.jm().format(this.startTime.toDate());
    String endString = new DateFormat.jm().format(this.endTime.toDate());

    return Stack(
      children: <Widget>[
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          )
        ),
        Hero(
          tag: 'eventsCardImg'+this.docId,
          child: CachedNetworkImage(
            imageUrl: this.image,
            imageBuilder: (context, imageProvider) => Container(
              height: screenWidth,
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )
              )
            ),
            placeholder: (context, url) => Image(
              image: AssetImage('assets/images/loadingPlaceHolder.png')
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.red,
              size: 30.0
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
                height: MediaQuery.of(context).size.width*0.7,
                color: Colors.transparent,
              )
            ),
            /*Row(
              children: <Widget>[
                Spacer(
                  flex: 100
                ),
                Expanded(
                  flex: 1000,
                  child: Hero(
                    tag: 'eventsCardTitle'+this.docId,
                    child: AutoSizeText(
                      this.name,
                      textAlign: TextAlign.left,
                      maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                      minFontSize: Theme.of(context).textTheme.headline.fontSize,
                      style: Theme.of(context).textTheme.headline
                    )
                  )
                )
              ],
            ),*/
            SizedBox(
              height: 20
            ),
            Container(
              margin: EdgeInsets.only(
                left: AppTheme.cardSideMargin,
                right: AppTheme.cardSideMargin,
                bottom: AppTheme.cardVerticalMargin
              ),
              padding: EdgeInsets.all(AppTheme.detailCardInnerPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
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
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'eventsCardTitle'+this.docId,
                    child: AutoSizeText(
                      this.name,
                      textAlign: TextAlign.left,
                      maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                      minFontSize: Theme.of(context).textTheme.headline.fontSize,
                      style: Theme.of(context).textTheme.headline
                    )
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Container(
                    height: 1.5,
                    color: Theme.of(context).accentColor
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 2
                      ),
                      Expanded(
                        flex: 10,
                        child: timeComponent(context, startString, endString)
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 5,
                        child: dateComponent(context, dateString)
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10
                  ),
                  SizedBox(
                    height: 30,
                    child: locationComponent(context, bigLocation, tinyLocation)
                  ),
                  SizedBox(
                    height: 15
                  ),
                  Container(
                    height: 1.5,
                    color: Theme.of(context).accentColor
                  ),
                  SizedBox(
                    height: 10
                  ),
                  Visibility(
                    visible: this.description != "",
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10
                        ),
                        Text(
                          this.description,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption
                        ),
                        SizedBox(
                          height: 10
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.favorite_border,
                    size: 24.0,
                    color: Colors.red
                  ),
                ],
              )
            )
          ]
        )
      ],
    );
  }
}
*/