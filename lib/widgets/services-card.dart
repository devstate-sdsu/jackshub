import 'package:flutter/material.dart';



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

    return Container(
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
    );
  }
}