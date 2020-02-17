import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jackshub/screens/home.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'lib/assets/icons/devstate-logo.svg',
              color: Theme.of(context).accentColor,
              width: 100.0,
              height: 100.0,
            ),
            SizedBox(
              height: 20.0
            ),
            Text(
              "Made by students, for students.",
              style: Theme.of(context).textTheme.title
            )
          ],
        )
      )
    );
  }
}