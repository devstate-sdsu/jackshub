import 'package:cloud_firestore/cloud_firestore.dart';



//class DayHours {

//}


class TimeFrame {
  final Timestamp start;
  final Timestamp end;
  TimeFrame(this.start, this.end);
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