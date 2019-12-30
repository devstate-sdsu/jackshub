//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/widgets.dart';

/*    STRICTLY FOR REFERENCE PURPOSES         */


/*

class DetailedServicesScreen extends StatelessWidget {
  DetailedServicesScreen({
    this.docId,
  });

  final String docId;

  final double cardBorderRadius = 15.0;
  final double cardSidePadding = 20.0;
  
  final Color shadowColor = Color.fromRGBO(0,0,0,0.25);
  final double shadowBlurRadius = 20.0;
  final Offset shadowOffset = Offset(0,5);

  Future<DocumentSnapshot> _getSnapshot(String docId) async {
    DocumentSnapshot snapshot;
    await Firestore.instance.collection('foodCol').document(docId).get().then((DocumentSnapshot docsnap) {
      snapshot = docsnap;
    });
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSnapshot(docId),
      builder: (context, snapshot) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: <Widget>[
              Image(
                //alignment: Alignment.topRight,
                image: NetworkImage(snapshot.data["image"]),
                fit: BoxFit.fitWidth,
              ),
              ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print(" ON TAP GESTURE ");
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 400,
                      color: Colors.transparent,
                    )
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(
                        flex: 100
                      ),
                      Expanded(
                        flex: 1000,
                        child: Text(
                          snapshot.data["name"],
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.title,
                        )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: cardSidePadding,
                      right: cardSidePadding, 
                    ),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: shadowBlurRadius,
                          offset: shadowOffset,
                        )
                      ],
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          snapshot.data["description"][0],
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          snapshot.data["description"][1],
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    )
                  )
                ],
              )
            ]
          )
        );
      }
    );
  }
}












builder: (context, snapshot) {
            switch (snapshot.connectionState) {

                ///when the future is null
              case ConnectionState.none:
                return Text(
                  'Press the button to fetch data',
                  textAlign: TextAlign.center,
                );

              case ConnectionState.active:

                ///when data is being fetched
              case ConnectionState.waiting:
                return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));

              case ConnectionState.done:
                ///task is complete with an error (eg. When you
                ///are offline)
                if (snapshot.hasError)
                  return Text(
                    'Error:\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                ///task is complete with some data
                return Text(
                  'Fetched Data:\n\n${snapshot.data.title}',
                  textAlign: TextAlign.center,
                );
            }
          },














Future<String> _calculation = Future<String>.delayed(
  Duration(seconds: 2),
  () => 'Data Loaded',
);

Widget build(BuildContext context) {
  return FutureBuilder<String>(
    future: _calculation, // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      List<Widget> children;

      if (snapshot.hasData) {
        children = <Widget>[
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Result: ${snapshot.data}'),
          )
        ];
      } else if (snapshot.hasError) {
        children = <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: ${snapshot.error}'),
          )
        ];
      } else {
        children = <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          )
        ];
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      );
    },
  );
}












// Flutter code sample for FutureBuilder

// This sample shows a [FutureBuilder] that displays a loading spinner while it
// loads data. It displays a success icon and text if the [Future] completes
// with a result, or an error icon and text if the [Future] completes with an
// error. Assume the `_calculation` field is set by pressing a button elsewhere
// in the UI.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Future<String> _calculation = Future<String>.delayed(
    Duration(seconds: 2),
    () => 'Data Loaded',
  );

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _calculation, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Result: ${snapshot.data}'),
            )
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}






















            Container(
              margin: EdgeInsets.only(
                left: cardSidePadding,
                right: cardSidePadding,
              ),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: shadowBlurRadius,
                    offset: shadowOffset,
                  )
                ]
              ),
              child: FutureBuilder(
                future: _getSnapshot(docId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    
                  } else if (snapshot.hasError) {
                    return Text(
                      'Sorry, an error occurred!',
                      style: Theme.of(context).textTheme.title
                    );
                  } else {    // while loading...
                    return Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).indicatorColor)
                        ),
                        width: 60.0,
                        height: 60.0
                      )
                    );
                  }
                  return SizedBox(
                    height: 30.0,
                  );
                }
              )
            )



*/