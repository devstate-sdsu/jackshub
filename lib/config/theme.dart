import 'package:flutter/material.dart';



var lightTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  backgroundColor: Colors.white,
  cardColor: Colors.white,

  textTheme: TextTheme(
    title: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    caption: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    )
  )
);



var darkTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  backgroundColor: Colors.grey[900],
  cardColor: Colors.grey[850],

  textTheme: TextTheme(
    title: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    caption: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    )
  )
);
