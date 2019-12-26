import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jackshub/config/router.dart';



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
//class _ServicesCard extends State<ServicesCard> {

  //bool _touched = false;
  AnimationController _controller;
  Animation _animation;

  double cardTouchedScale = 0.95;
  double cardRegularScale = 1;
  var cardScale = 1.0;  // The card's scale is dependent on this property as it animates.
  int cardScaleDuration = 200;  // Apparently takes integers only. (In milliseconds)

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

/*
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: cardTouchedScale,
      upperBound: cardRegularScale,
      duration: Duration(milliseconds: cardScaleDuration)
    )
    ..addListener(() {
      /*setState(() {
        //cardScale = _controller.value;
      });*/
    });

    _animation = new Tween(
      begin: 0.0, 
      end: 1.0
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
        reverseCurve: Curves.decelerate
      )
    )
    ..addListener(() {
      setState(() {
        cardScale = _animation.value;
      });
    });

    super.initState();
  }
*/

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    print("CARD cardBase + WIDGET DOC ID ");
    print('cardBase'+widget.docId);
    
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
            print("DOCID STRING: ");
            print(docId);
            ApplicationRouter.router.navigateTo(context, "detailedServices/$docId", transition: TransitionType.fadeIn, transitionDuration: const Duration(milliseconds: 1000));
          },
          onTapCancel: () {
            _controller.reverse();
          },
          /*onTap: () {
            _controller.forward();
            String docId = widget.docId;
            print("DOCID STRING: ");
            print(docId);
            ApplicationRouter.router.navigateTo(context, "detailedServices/$docId", transition: TransitionType.native);
          },*/
          child: Transform.scale(
            scale: _animation.value,
            child: Container(
              alignment: Alignment.center,
              /*child: Stack(
                children: <Widget>[*/
                  /*Hero(     // We want to animate the card such that it 'expands' into the screen. We make a 'fake' background card for this.
                    tag: 'cardBase'+widget.docId,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                        horizontal: cardSidePadding,
                        vertical: cardVerticalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: shadowBlurRadius,
                            offset: shadowOffset,
                          )
                        ]
                      ),
                    )
                  ),*/
                  child: Hero(
                    tag: 'cardBase'+widget.docId,
                      child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                        horizontal: cardSidePadding,
                        vertical: cardVerticalPadding,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: shadowBlurRadius,
                            offset: shadowOffset,
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            image: DecorationImage(
                              alignment: Alignment(-1.0,0.0),
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(
                                widget.img
                              )
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Spacer(   // We make an empty space so that the background image is showing.
                                flex: 250
                              ),
                              Expanded( // Here is the actual contents of the card. 
                                flex: 500,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Column(    // We place the contents inside a 'column'.
                                    children: <Widget>[
                                      SizedBox(     // This acts as the top padding.
                                        height: 12  
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Spacer(   // This acts as the left padding so that the text doesn't go right up to the picture.
                                            flex: 50
                                          ),
                                          Expanded(
                                            flex: 1000,
                                            //child: Hero(    // We wrap the title in a hero so that it transitions to the next screen.
                                              //tag: 'cardTitle'+widget.docId,
                                              child: Text(
                                                widget.name,
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context).textTheme.title,
                                              )
                                            //)
                                          )
                                        ],
                                      ),
                                      SizedBox(     // Separate the title from the description by a bit.
                                        height: 5
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Spacer(   // This acts as the left padding for the card's summary.
                                            flex: 50
                                          ),
                                          Expanded(
                                            flex: 1000,
                                            child: Text(
                                              widget.summary,
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context).textTheme.caption,
                                            )
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12    // Separate the summary and the 'Currently Open' text.
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Spacer(
                                            flex: 50
                                          ),
                                          Expanded(
                                            flex: 1000,
                                            child: Text(
                                              "Currently Closed FOREVER because you suck",
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context).textTheme.caption,
                                            )
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12    // This acts as the bottom padding of the card.
                                      )
                                    ],
                                  )
                                )
                              ),
                              Spacer(   // This acts as the right padding for the card.
                                flex: 30
                              )
                            ],
                          )
                        )
                      )
                    )
                  )
                //],
            )
          )
        );
        //);
      }
    );
  }
}





/*
int initialDragTimeStamp;
int currentDragTimeStamp;
int timeDelta;
double initialPositionY;
double currentPositionY;
double positionYDelta;

void _startVerticalDrag(details) {
  // Timestamp of when drag begins
  initialDragTimeStamp = details.sourceTimeStamp.inMilliseconds;

  // Screen position of pointer when drag begins
  initialPositionY = details.globalPosition.dy;
}

void _whileVerticalDrag(details) {
  // Gets current timestamp and position of the drag event
  currentDragTimeStamp = details.sourceTimeStamp.inMilliseconds;
  currentPositionY = details.globalPosition.dy;

  // How much time has passed since drag began
  timeDelta = currentDragTimeStamp - initialDragTimeStamp;

  // Distance pointer has travelled since drag began
  positionYDelta = currentPositionY - initialPositionY;

  // If pointer has moved more than 50pt in less than 50ms... 
  if (timeDelta < 50 && positionYDelta > 50) {
    // close modal
  }
}

GestureDetector(
  onVerticalDragStart: (details) => _startVerticalDrag(details),
  onVerticalDragUpdate: (details) => _whileVerticalDrag(details)
)
*/






/*
// code to retrieve data:

Future<QuerySnapshot> getFeedsfromFb() async {
  var data = await Firestore.instance
      .collection('feedItem')
      .orderBy('feedId', descending: true).getDocuments();
  return data;
}

// building widget:

Widget feed() {
  return Container(
    width: deviceWidth,
    height: deviceHeight / 3,
    child: FutureBuilder(
        future: getFeedsfromFb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.documents.length > 10
                  ? 10
                  : snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: deviceWidth / 2.5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => FeedIntro(
                                  snapshot.data.documents[index]['feedId'])));
                    },
                    child: Card(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // width: 150,
                          height: 150,
                          foregroundDecoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data.documents[index]['feedImage'],
                                  ),
                                  fit: BoxFit.fill)),
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data.documents[index]['title']),
                        )),
                      ],
                    )),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Sorry Something went wrong!'));
          } else {
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 50,
                height: 50,
              ),
            );
          }
        }),
  );
}

*/




















































/*

class ServicesCard extends StatelessWidget {
  ServicesCard({
    this.name,
    this.summary,
    this.img,
    this.docId
  });

  final String name;
  final String summary;
  final String img;
  final String docId;

  @override
  Widget build(BuildContext context) {

    double cardSidePadding = 20.0;
    double cardVerticalPadding = 10.0;
    double cardBorderRadius = 15.0;

    Color shadowColor = Color.fromRGBO(0,0,0,0.25);
    double shadowBlurRadius = 20.0;
    Offset shadowOffset = Offset(0,5);

    return GestureDetector(
      onTap: () {
        ApplicationRouter.router.navigateTo(context, "detailedServices/$docId", transition: TransitionType.fadeIn);
      },

      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: cardSidePadding,
          vertical: cardVerticalPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: shadowBlurRadius,
              offset: shadowOffset,
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              image: DecorationImage(
                alignment: Alignment(-1.125,0.0),
                fit: BoxFit.fitHeight,
                //image: Image.network(this.img).image,
                image: NetworkImage(
                  this.img
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(
                  flex: 250,
                ),
                Expanded(
                  flex: 500,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 12
                        ),
                        Row(
                          children: <Widget>[
                            Spacer(
                              flex: 50,
                            ),
                            Expanded(
                              flex: 1000,
                              child: Text(
                                this.name,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.title,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5
                        ),
                        Row(
                          children: <Widget>[
                            Spacer(
                              flex: 50,
                            ),
                            Expanded(
                              flex: 1000,
                              child: Text(
                                this.summary,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12
                        ),
                        Row(
                          children: <Widget>[
                            Spacer(
                              flex: 50,
                            ),
                            Expanded(
                              flex: 1000,
                              child: Text(
                                "Currently: CLOSED FOREVER because you suck",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12
                        )
                      ],
                    )
                  )
                ),
                Spacer(
                  flex: 30,
                )
              ]
            )
          )
        )
      )
    );
  }
}

*/