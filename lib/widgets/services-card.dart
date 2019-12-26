import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jackshub/config/router.dart';
import 'package:jackshub/util/database_helpers.dart';



class ServicesCard extends StatefulWidget {
  final String name;
  final String summary;
  final String img;
  final String docId;

  const ServicesCard({
    Key key,
    this.name,
    this.summary,
    this.img,
    this.docId
  }): super(key: key);

  @override
  _ServicesCard createState() => _ServicesCard();
}




class _ServicesCard extends State<ServicesCard> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  double cardTouchedScale = 0.94;
  double cardRegularScale = 1;
  var cardScale = 1.0;
  int cardScaleDuration = 250;

  double cardSidePadding = 20.0;
  double cardVerticalPadding = 10.0;
  double cardBorderRadius = 15.0;

  Color shadowColor = Color.fromRGBO(0,0,0,0.25);
  double shadowBlurRadius = 20.0;
  Offset shadowOffset = Offset(0,5);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: cardScaleDuration
      )
    );

    _animation = Tween(
      begin: cardRegularScale, 
      end: cardTouchedScale
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeInQuad
    ));
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
            _controller.forward();
            String docId = widget.docId;
            ApplicationRouter.router.navigateTo(
              context,
              "detailedServices/$docId",
              transition: TransitionType.fadeIn,
              transitionDuration: Duration(milliseconds: 1000)
            );
          },

          onTapCancel: () {
            _controller.reverse();
          },

          child: Transform.scale(
            scale: _animation.value,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: cardSidePadding,
                vertical: cardVerticalPadding
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: shadowBlurRadius,
                    offset: shadowOffset,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 350,
                    child: Hero(
                      tag: 'cardImg'+widget.docId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(cardBorderRadius),
                          bottomLeft: Radius.circular(cardBorderRadius),
                        ),
                        child: Image(
                          image: NetworkImage(
                            widget.img
                          )
                        )
                      ),
                    )
                  ),
                  Spacer(
                    flex: 10,
                  ),
                  Expanded(
                    flex: 750,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0
                        ),
                        Hero(
                          tag: 'cardTitle'+widget.docId,
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.title,
                          )
                        ),
                        SizedBox(
                          height: 5.0
                        ),
                        Text(
                          widget.summary,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(
                          height: 10.0
                        ),
                        Text(
                          "Currently: Closed, FOREVER because you suck.",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.caption
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