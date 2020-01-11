import 'package:flutter/material.dart';



var lightTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.black54,
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
    ),
    display2: TextStyle(    // Used as 'DateString' date component and 'TimeString' time component text
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
      color: Colors.black54
    ),
    display3: TextStyle(    // Used as 'BigLocation' text
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
      color: Colors.black54,
    ),
    display4: TextStyle(    // Used as 'LittleLocation' text
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
      color: Colors.black54,
    )
  )
);



var darkTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  accentColor: Colors.white,
  backgroundColor: Colors.black,
  cardColor: Colors.grey[900],
  indicatorColor: Colors.white,

  textTheme: TextTheme(
    title: TextStyle(
      //fontFamily: 'Roboto',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline: TextStyle(
      //fontFamily: 'Roboto',
      fontSize: 35.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    caption: TextStyle(
      //fontFamily: 'Roboto', 
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    display2: TextStyle(    // Used as 'DateString' date component and 'TimeString' time component text
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
      color: Colors.white70
    ),
    display3: TextStyle(    // Used as 'BigLocation' text
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
      color: Colors.white70,
    ),
    display4: TextStyle(    // Used as 'LittleLocation' text
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
      color: Colors.white70,
    )
  )
);



class AppTheme {

  // Global theming of cards
  static double cardRadius = 15.0;
  static double cardSideMargin = 20.0;
  static double cardVerticalMargin = 10.0;

  // Global theming of card touch depress animation
  static double cardTouchedScale = 0.94;
  static int cardAnimateDuration = 250;
  static Curve cardForwardCurve = Curves.fastOutSlowIn;
  static Curve cardReverseCurve = Curves.easeInQuad;

  // Global theming of the shadows underneath the cards
  static Color shadowColor = Color.fromRGBO(0, 0, 0, 0.25);
  static double shadowBlurRadius = 20.0;
  static Offset shadowOffset = Offset(0, 5);

  // Global theming of auto-sized texts (used in location, date, time texts)
  static double bigLocationTextSize = 14.0;
  static double littleLocationTextSize = 12.0;
  static double dateStringTextSize = 12.0;
  static double timeStringTextSize = 12.0;

}