import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jackshub/config/router.dart';
import 'package:jackshub/util/database_helpers.dart';



/*class ServicesRoutingParameters {
  final String name;
  final String image;
  final String docId;
  ServicesRoutingParameters(this.name, this.image, this.docId);
}*/

class ServicesCard extends StatefulWidget {
  final String name;
  final String summary;
  final String image;
  final String status;
  final String docId;

  const ServicesCard({
    Key key,
    this.name,
    this.summary,
    this.image,
    this.status,
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
  double cardSidePadding = 20.0;
  double cardVerticalPadding = 10.0;
  double cardBorderRadius = 15.0;

  Color shadowColor = Color.fromRGBO(0, 0, 0, 0.25);
  double shadowBlurRadius = 20.0;
  Offset shadowOffset = Offset(0, 5);

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
    print("widget image");
    print(widget.image);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return GestureDetector(

          onTapDown: (TapDownDetails details) {
            _controller.forward();
          },

          onTapUp: (TapUpDetails details) {
            _controller.reverse();
            //String docId = widget.docId;
            //String name = widget.name;
            //String image = widget.image;
            //var paramdata = '{"docId":'+docId+',"name":'+name+',"image":'+image+'}';
            /*Map<String, dynamic> paramdata = {
              "docId": docId,
              "name": name,
              //"image": image
            };*/
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
                horizontal: cardSidePadding,
                vertical: cardVerticalPadding
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: shadowBlurRadius,
                    offset: shadowOffset
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
                          topLeft: Radius.circular(cardBorderRadius),
                          bottomLeft: Radius.circular(cardBorderRadius)
                        ),
                        child: Container(
                          //color: Colors.black87,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                widget.image
                              )
                            )
                          )
                        )
                        /*child: FadeInImage.assetNetwork(
                          placeholder: 'lib/assets/images/loadingPlaceHolder.png',
                          image: widget.img,
                          imageScale: 2.1,
                          //fit: BoxFit.fitHeight
                        )*/
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
                          tag: 'servicesCardTitle'+widget.docId,
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
                          child: Text(
                            widget.summary,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3
                          )
                        ),
                        SizedBox(
                          height: 10.0
                        ),
                        Text(
                          widget.status,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption
                        ),
                        SizedBox(
                          height: 10.0
                        )
                      ],
                    )
                  ),
                  Spacer(
                    flex: 20
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

