import 'package:flutter/material.dart';



var lightTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  backgroundColor: Colors.white,
  cardColor: Colors.white,
  indicatorColor: Colors.black,
  

  textTheme: TextTheme(
    title: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 35.0,
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
  primaryColor: Colors.black,
  backgroundColor: Colors.black,
  cardColor: Colors.grey[900],
  indicatorColor: Colors.white,

  textTheme: TextTheme(
    title: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 35.0,
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
