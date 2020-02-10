import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:jackshub/config/theme.dart';



String convertMonthStringToNumber(String month) {
  if (month == "Jan") {
    return "01";
  } else if (month == "Feb") {
    return "02";
  } else if (month == "Mar") {
    return "03";
  } else if (month == "Apr") {
    return "04";
  } else if (month == "May") {
    return "05";
  } else if (month == "Jun") {
    return "06";
  } else if (month == "Jul") {
    return "07";
  } else if (month == "Aug") {
    return "08";
  } else if (month == "Sep") {
    return "09";
  } else if (month == "Oct") {
    return "10";
  } else if (month == "Nov") {
    return "11";
  } else if (month == "Dec") {
    return "12";
  } else {
    return null;
  }
}



String holidayDayParser(dynamic dayString) {
  String newString = dayString.toString();
  String year = newString.substring(11);
  String month = convertMonthStringToNumber(newString.substring(4, 7));
  String date = newString.substring(8, 10);
  print(year+"-"+month+"-"+date);
  return(year+"-"+month+"-"+date);
}



void iterateHolidayDays(List<dynamic> days) {
  days.forEach((element) => holidayDayParser(element['day']));
}



void iterateHolidays(DocumentSnapshot doc, List<dynamic> holidayHours) {
  DateTime currentDay = DateTime.now();
  String currentDate = currentDay.toString().substring(0, 10);
  print("CURRENT DATE IS ... :");
  print(currentDate);
  print("THE DATES!   ");
  holidayHours.forEach((holidays) => iterateHolidayDays(holidays['days']));


  // print(doc.data['name']);
  // var holidayDaysString = new List<String>();
  // var holidayDays = new List<DateTime>();
  // holidayHours.forEach((day) => {
  //   day['days'].forEach((element) => {
  //     //holidayDayParser(element['day'])
  //     holidayDaysString.add(holidayDayParser(element['day']))
  //   })
  // });
  // holidayDaysString.forEach((dayString) => {
  //   holidayDays.add(DateTime.parse(dayString))
  // });
  // DateTime currentDay = DateTime.now();
  // print(holidayDays);
  // print(currentDay);
}



Map<int, DateTime> convertToHourSlots(dynamic hours) {
  hours.forEach((slot) => {
    
  });
}



Map<String, dynamic> getHoursByWeekDay(int weekDay, DocumentSnapshot doc) {
  Map<String, DateTime> hourSlots;
  if (weekDay == 1) {         // Monday
    return doc.data['hours']['regularHours']['days'][1];
  } else if (weekDay == 2) {  // Tuesday
    return doc.data['hours']['regularHours']['days'][2];
  } else if (weekDay == 3) {  // Wednesday
    return doc.data['hours']['regularHours']['days'][3];
  } else if (weekDay == 4) {  // Thursday
    return doc.data['hours']['regularHours']['days'][4];
  } else if (weekDay == 5) {  // Friday
    return doc.data['hours']['regularHours']['days'][5];
  } else if (weekDay == 6) {  // Saturday
    return doc.data['hours']['regularHours']['days'][6];
  } else if (weekDay == 7) {  // Sunday
    return doc.data['hours']['regularHours']['days'][0];
  }
}



void checkCurrentRegular(DocumentSnapshot doc) {
  DateTime currentTime = DateTime.now();
  print(currentTime.weekday);
}


Widget currentServiceStatusText(context, DocumentSnapshot doc) {
  // Map<String, dynamic> docdata = doc.data;
  // List<dynamic> regularHours = docdata['hours']['regularHours']['days']; // returns an array containing two things: a string giving the 'day' tag and an 'hours' array
  // List<dynamic> holidayHours = docdata['hours']['holidayHours'];
  // iterateHolidays(doc, holidayHours);
  //print(docdata['name']);
  //print(regularHours);
  checkCurrentRegular(doc);
  return AutoSizeText(
    "Hello",
    maxLines: 1,
    textAlign: TextAlign.left,
    maxFontSize: AppTheme.cardDescriptionTextSize.max,
    minFontSize: AppTheme.cardDescriptionTextSize.min,
    style: TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto'
    )
  );
}





// Check what day it is today
// 11/12/2020

// Go through HolidayDays:
// 13/12/2020
// 14/12/2020
// 15/12/2020

// Go through 'HolidayHours' array through StreamBuilder
// Go through each holiday "day" through StreamBuilder to get Timeframes for that day
// For each of the Timeframes, parse the two 'Start' and 'End' times into a formatted string
// Convert the formatted strings into 'Start' and 'End' Timestamps
// Combine the Timestamps into a 'Timeframe' class



// Iterate on each time frame (for that day) ...
// A time frame is an object that includes a 'start' and 'end'
// Do an 'IsBefore' && 'IsAfter' call using ForEach() on #TimeFrame objects
// Return a bool (true) if open currently or (false) if closed



/*
String stringTimeParse(String input) {
  return DateTime.
}


Timestamp stringToTimeStamp(String string) {

}
*/



// void printOutputDebug(dynamic day) {
//   print("DAY: ");
//   print(day['days']);
//   print("THE DAYS ELEMENTS!  ");
//   day['days'].forEach((element) => print(element['day']));
// }
