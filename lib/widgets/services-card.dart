import 'package:flutter/material.dart';
import 'package:jackshub/config/router.dart';
import 'package:jackshub/config/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ServicesCard extends StatefulWidget {
  final String name;
  final String summary;
  final String image;
  //final String status;
  final String docId;

  const ServicesCard({
    Key key,
    this.name,
    this.summary,
    this.image,
    //this.status,
    this.docId
  }): super(key: key);

  @override
  _ServicesCard createState() => _ServicesCard();
}



class _ServicesCard extends State<ServicesCard> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  int transitionDuration = 1000;  // in milliseconds

  double cardTouchedScale = 0.94;
  double cardRegularScale = 1.0;
  int cardAnimateDuration = 250;  // in milliseconds
  var cardScale = 1.0;

  double cardVerticalSize = 135.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: cardAnimateDuration,
      )
    );
    _animation = Tween(
      begin: cardRegularScale,
      end: cardTouchedScale
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeInQuad
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
                widget.name,
                widget.image,
                widget.docId,
              ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 350,
                    child: Hero(
                      tag: 'servicesCardImg'+widget.docId,
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
                          placeholder: (context, url) => Image(
                            image: AssetImage('assets/images/loadingPlaceHolder.png')
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
                          child: Hero(
                            tag: 'servicesCardTitle'+widget.docId,
                            child: AutoSizeText(
                              widget.name,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              maxFontSize: AppTheme.cardSmallEventsTitleTextSize.max,
                              minFontSize: AppTheme.cardSmallEventsTitleTextSize.min,
                              style: Theme.of(context).textTheme.title
                            )
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
                              child: AutoSizeText(
                                "Currently open until 4:00pm",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                maxFontSize: AppTheme.cardDescriptionTextSize.max,
                                minFontSize: AppTheme.cardDescriptionTextSize.min,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto'
                                )
                              )
                            ),
                          ],
                        ),
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
 