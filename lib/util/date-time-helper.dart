import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:jackshub/config/theme.dart';


class HourSlot {
  final DateTime start;
  final DateTime end;
  HourSlot({this.start, this.end});
}

class Day {
  final String holidayName;   // defaults to ""
  final List<HourSlot> slots;
  final DateTime date;  // we need a separate date to check for days as usually if the service is closed, the 'slots' would be empty.
  //final bool closed;    // defaults to false; added because error arises when 'slots' is empty because there is no 'hours' in holidayDays
                        // now this is used to symbolize a 'closed' holiday Day, because the dayChecker for holidayDays require a valid 'slot' but
                        // for a closed holiday Day, there should be no slots.
  //final String date;    // optional parameter, used for incomingDays widget on detailed servicecard; "Monday"     DEPRECATED
  Day({this.holidayName = "", this.slots, this.date});
}

class Holiday {
  final String name;
  final List<Day> dates;
  Holiday({this.name, this.dates});
}

class ServiceHours {      // This class will be created (called) every time the service card will be made
  final List<Holiday> holidays;
  final List<Day> incomingDays;   // Because of that, we can simply insert a list of the next 6 days here (including the current day, today), in a positioned array.
                                  // [0] for today, [1] for tomorrow, [2] for after-tomorrow, etc... up to [6].
  ServiceHours({this.holidays, this.incomingDays});
}

Map<int, String> weekDays = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday"
};

Map<String, String> monthsOfYear = {
  "Jan": "01",
  "Feb": "02",
  "Mar": "03",
  "Apr": "04",
  "May": "05",
  "Jun": "06",
  "Jul": "07",
  "Aug": "08",
  "Sep": "09",
  "Oct": "10",
  "Nov": "11",
  "Dec": "12"
};

DateTime getDateTime(String time, String year, String month, String day) {
  String parsedTime = DateFormat.Hms().format(DateFormat("hh:mma").parse(time));
  return DateTime.parse('$year-$month-$day $parsedTime');
}

Map<String, String> parseHolidayDate(String input) {
  Map<String, String> output = {
    "year": input.substring(11),
    "month": monthsOfYear[input.substring(4, 7)],
    "day": input.substring(8, 10)
  };
  return output;
}

Day getWeekDay(DateTime day, DocumentSnapshot doc) {
  List<HourSlot> curSlots = [];
  //curSlots.clear();
  String dayYear = day.toString().substring(0, 4);
  String dayMonth = day.toString().substring(5, 7);
  String dayDay = day.toString().substring(8, 10);
  List<dynamic> docDays = doc.data['hours']['regularHours']['days'];
  if (docDays.isNotEmpty) {   // Checker to avoid error
    for (var days in docDays) {     // We have to iterate through these because if the service is closed, there is no entry for it in the 'days' array
      if (days['day'] == weekDays[day.weekday]) {
        List<dynamic> docHours = days['hours'];
        if (docHours.isNotEmpty) {
          for (var hourSlots in docHours) {
            curSlots.add(
              HourSlot(  // We already have the desired date (ie. 05-02-2020 xx:xx:xx), we just want to make the times for that date (ie. 05-02-2020 hour:minute:second)
                start: getDateTime(hourSlots['start'], dayYear, dayMonth, dayDay),
                end: getDateTime(hourSlots['end'], dayYear, dayMonth, dayDay)
              )
            );
          }
          //return Day(slots: curSlots, date: getDateTime('12:00AM', dayYear, dayMonth, dayDay));
        } else {
          //print("Closed on ${weekDays[day.weekday]}");
          //return Day(slots: curSlots, date: getDateTime('12:00AM', dayYear, dayMonth, dayDay));
        }
      }
    }
  } else {
    //print("docDays for getWeekDay() is empty...?");
  }
  return Day(slots: curSlots, date: getDateTime('12:00AM', dayYear, dayMonth, dayDay));      // If service is closed on a regular week day, then the Day.slots list would be empty.
}

// If the holidayDays does NOT have open hours, then the holidayDays['hours'] list will be empty

Day checkDay(DateTime day, List<Holiday> holidaysList, DocumentSnapshot doc) {    // The holidays list will already be populated with good data (a list of Days containing a bunch of HourSlot's)
  // bool isHoliday = false;                   // We use a bool here because if we return the 'Day' object in the loop, then it does not give them a chance to go through the ENTIRE list. Only once.
  Day curDay = getWeekDay(day, doc);
  if (holidaysList.isNotEmpty) {
    for (var holidays in holidaysList) {    // Multiple holidays possible, check all the holidays (ie. Spring Break, Winter Break, etc.)
      for (var holidayDays in holidays.dates) {   // Loop through the dates of a holiday, with each class 'Day' as 'holidayDays'
        //if (holidayDays.slots.isEmpty) {
          int holidayDaysYear = holidayDays.date.year;
          int holidayDaysMonth = holidayDays.date.month;
          int holidayDaysDay = holidayDays.date.day;
          if (day.year == holidayDaysYear && day.month == holidayDaysMonth && day.day == holidayDaysDay) {
            // The day being checked is a holiday!
            // isHoliday = true;
            // return holidayDays;
            curDay = holidayDays;
          } else {
            // isHoliday = false;
            // return getWeekDay(day, doc);
          }
        //}
      }
    }
  } else {
    // isHoliday = false;
    // return getWeekDay(day, doc);
  }
  return curDay;
}

List<Day> getIncomingDays(DocumentSnapshot doc, List<Holiday> holidayslist) {   // Multiple holidays is possible
  //List<DateTime> projectedDays = [];
  List<Day> incomingDays = [];
  // for (int i=0; i<=6; i++) {
  //   projectedDays.add(DateTime.now().add(Duration(days: i)));
  // }
  for (int i=0; i<=6; i++) {
    incomingDays.add(checkDay(DateTime.now().add(Duration(days: i)), holidayslist, doc));
  }
  //print('completed projections: ');
  //print(projectedDays);
  // for (var datetimes in projectedDays) {
  //   incomingDays.add(
  //     checkDay(datetimes, holidayslist, doc)
  //   ); // Will check if holiday or regular day
  // }
  //print('completed checking projected days');
  //print(incomingDays);
  return incomingDays;
}

Day getHolidayDay(Map<String, String> parsedDate, List<dynamic> docHours, String holidayName) {
  List<HourSlot> curSlots = [];
  if (docHours.isNotEmpty) {
    for (var hours in docHours) {   // each 'hours' map contains an 'end' and a 'start'
      curSlots.add(
        HourSlot(
          start: getDateTime(hours['start'], parsedDate['year'], parsedDate['month'], parsedDate['day']),
          end: getDateTime(hours['end'], parsedDate['year'], parsedDate['month'], parsedDate['day'])
        )
      );
    }
  } else {  // the service is closed for this particular holidayDay, so we make 
    //return Day(holidayName: holidayName, slots: curSlots, date: getDateTime('00:00:00', parsedDate['year'], parsedDate['month'], parsedDate['day']));
  }
  return Day(holidayName: holidayName, slots: curSlots, date: getDateTime('12:00AM', parsedDate['year'], parsedDate['month'], parsedDate['day']));
}

List<Day> getHolidayDaysList(List<dynamic> docDays, String holidayName) {
  List<Day> curDays = [];
  if (docDays.isNotEmpty) {
    for (var days in docDays) {   // a 'days' object is a map that contains a String 'day' and an array 'hours'
      Map<String, String> parsedDate = parseHolidayDate(days['day']);
      //print(parsedDate);
      curDays.add(
        getHolidayDay(parsedDate, days['hours'], holidayName)
      );
      //print(curDays);
    }
  } else {
    //print("docDays for getHolidayDaysList() are empty...?");
  }
  return curDays;
}

List<Holiday> getListOfHolidays(DocumentSnapshot doc) {
  List<Holiday> holidaysList = [];
  List<dynamic> docHolidays = doc.data['hours']['holidayHours'];
  //print(docHolidays);
  if (docHolidays.isNotEmpty) {
    //print("docHolidays is not empty!");
    for (var holiday in docHolidays) {  // 'holiday' var contains a String 'name', and an array 'days'
      holidaysList.add(
        Holiday(
          name: holiday['name'],
          dates: getHolidayDaysList(holiday['days'], holiday['name'])
        )
      );
    }
  } else {  // there are no holidays for this particular service
    //print("No holidays for ${doc.data['name']}");
  }
  return holidaysList;
}

ServiceHours getHours(DocumentSnapshot doc) {
  List<Holiday> currentHolidays = getListOfHolidays(doc);
  //print("got holidays, completed task: ");
  //print(currentHolidays);
  List<Day> incomingDays = getIncomingDays(doc, currentHolidays);
  return ServiceHours(holidays: currentHolidays, incomingDays: incomingDays);
}




/*
ServiceHours testServiceHours = ServiceHours(
  holidays: [
    Holiday(
      name: "Spring Break",
      dates: [Day(), Day(), Day()]
    ),
    Holiday(
      name: "Winter Break",
      dates: [Day(), Day(), Day(), Day()]
    )
  ],
  incomingDays: [
    Day(),  // [0] Today
    Day(),  // [1] +1 Tomorrow
    Day(),  // [2] +2 After-tomorrow
    Day(),  // [3] +3
    Day(),  // [4] +4
    Day(),  // [5] +5
    Day(),  // [6] +6
  ]
);
*/












/*
String convertMonthStringToNumber(String month) {
  switch (month) {
    case "Jan":
      return "01";
    case "Feb":
      return "02";
    case "Mar":
      return "03";
    case "Apr":
      return "04";
    case "May":
      return "05";
    case "Jun":
      return "06";
    case "Jul":
      return "07";
    case "Aug":
      return "08";
    case "Sep":
      return "09";
    case "Oct":
      return "10";
    case "Nov":
      return "11";
    case "Dec":
      return "12";
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
*/


/*
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
*/

/*
Map<int, DateTime> convertToHourSlots(dynamic hours) {
  hours.forEach((slot) => {
    
  });
}
*/



/*
Map<String, dynamic> getHoursByWeekDay(int weekDay, DocumentSnapshot doc) {
  Map<String, dynamic> hourSlots = [
    "Monday": [{DateTime start, DateTime end}, {DateTime start, DateTime end}];
  ];



  return hourSlots;

  return doc.data['hours']['regularHours']['days'][weekDay];

  /*
  if (weekDay == 1) {         // Monday
    return doc.data['hours']['regularHours']['days'][];
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
  }*/
}*/



/*
String checkCurrentRegular(DocumentSnapshot doc) {
  List<dynamic> regularDays = doc.data['hours']['regularHours']['days'];

  int mondayHoursIndex = regularDays.indexWhere((hourSet) {
    return hourSet['day'] == 'Monday';
  });

  dynamic mondayHours = regularDays[mondayHoursIndex];

  List<dynamic> hours = mondayHours['hours'];

  List<Map<String, DateTime>> hourStrings = hours.map((hour) {
    return {
      "start": myFunc(hour['start']),
      "end": myFunc(hour['end']),
    };
  });

  DateTime currentTime = DateTime.now();
  print(currentTime.weekday);
  return currentTime.toString();
}


DateTime converHourToDateTimeWeekDay(String hour, String weekday) {
  DateTime currentDay = DateTime.now();

  for (int day = 0; day < 7; day++) {
    if (currentDay.weekday == weekdays[weekday]) {
      break;
    }
    currentDay = currentDay.add(new Duration(days: 1));
  }

  String convertedDay = '${currentDay.year}-${currentDay.month}-${currentDay.day} ${hour}:00:00';
  print(convertedDay);
  return DateTime.parse(convertedDay);
}
*/

















Widget makeSlotText(BuildContext context, String slotText) {
  return AutoSizeText(
    slotText,
    maxLines: 1,
    textAlign: TextAlign.right,
    maxFontSize: AppTheme.cardDescriptionTextSize.max,
    minFontSize: AppTheme.cardDescriptionTextSize.min,
    style: Theme.of(context).textTheme.display1
  );
}

Widget serviceStatusDivider() {
  return SizedBox(
    height: 5
  );
}

Widget serviceDayStatus(BuildContext context, Day day, DateTime projectedDate) {
  List<String> curSlots = [];
  //curSlots.clear();
  List<Widget> curSlotsWidget = [];
  String projectedDayOfWeek = weekDays[projectedDate.weekday];
  String holidayMarker;
  if (day.holidayName!="") {
    holidayMarker = ", (${day.holidayName})";
  } else {
    holidayMarker = "";
  }
  //String projectedDayOfMonth = projectedDate.day.toString();
  if (day.slots.isNotEmpty) {
    for (var hourSlots in day.slots) {
      //String slotStartmarker = DateFormat('a').format(hourSlots.start).toLowerCase();
      String slotStart = DateFormat('h:mm').format(hourSlots.start)+DateFormat('a').format(hourSlots.start).toLowerCase();
      String slotEnd = DateFormat('h:mm').format(hourSlots.end)+DateFormat('a').format(hourSlots.end).toLowerCase();
      curSlots.add('$slotStart - $slotEnd');
    }
  } else {  // Closed
    if (day.holidayName == "") {  // It's not a holiday but regularly, the service is closed.
      curSlots.add("Closed");
    } else {  // However, if it is closed because of a holiday...
      curSlots.add("Closed, ${day.holidayName}");
    }
  }
  print(curSlots.length);
  for (var slots in curSlots) {
    curSlotsWidget.add(
      makeSlotText(context, slots)
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AutoSizeText(
        "$projectedDayOfWeek$holidayMarker",
        maxLines: 1,
        textAlign: TextAlign.left,
        maxFontSize: AppTheme.cardDescriptionTextSize.max,
        minFontSize: AppTheme.cardDescriptionTextSize.min,
        style: Theme.of(context).textTheme.display1
      ),
      Spacer(
        flex: 1
      ),
      Flexible(
        flex: 6,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8
            ),
            Container(
              height: 1,
              color: Theme.of(context).accentColor
            )
          ],
        )
      ),
      Spacer(
        flex: 1
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: curSlotsWidget
      )
    ],
  );
}

Widget serviceIncomingDaysStatus(BuildContext context, ServiceHours serviceHours) {
  //List<DateTime> projectedDays = [];
  List<Widget> statusWidgets = [];
  //print(serviceHours.incomingDays);
  for (int i=0; i<=6; i++) {
    //projectedDays.add(DateTime.now().add(Duration(days: i)));
    //print(serviceHours.incomingDays[i]);
    statusWidgets.add(serviceDayStatus(context, serviceHours.incomingDays[i], DateTime.now().add(Duration(days: i))));
    statusWidgets.add(serviceStatusDivider());
  }
  // List<Widget> statusWidgets = [];
  // for (var day in serviceHours.incomingDays) {
  //   statusWidgets.add(serviceDayStatus(context, day));
  // }
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statusWidgets
    )
  );
}


Widget currentServiceStatus(BuildContext context, ServiceHours serviceHours) {
  bool isClosed = false;
  String statusText = "";
  if (serviceHours.incomingDays[0].slots.isNotEmpty) {
    DateTime currentTime = DateTime.now();
    for (var hourSlots in serviceHours.incomingDays[0].slots) {
      if (currentTime.isAfter(hourSlots.start) && currentTime.isBefore(hourSlots.end)) {  // currently, the service is open (within a time slot)
        String nextClosingTime = DateFormat('h:mm').format(hourSlots.end)+DateFormat('a').format(hourSlots.end).toLowerCase();
        if (nextClosingTime=="11:59pm") {
          // The service closes at midnight OR it is tomorrow morning (in the day tomorrow)
          if (serviceHours.incomingDays[1].slots.isNotEmpty) {  // check if it's not closed tomorrow but to also avoid errors on calling for() on empty
            for (var tomorrowHourSlots in serviceHours.incomingDays[1].slots) {
              int tomorrowStartHour = tomorrowHourSlots.start.hour;
              int tomorrowStartMinute = tomorrowHourSlots.start.minute;
              int tomorrowEndHour = tomorrowHourSlots.end.hour;
              int tomorrowEndMinute = tomorrowHourSlots.end.minute;
              if (tomorrowStartHour == 0 && tomorrowStartMinute == 0) {   // If we have an hour slot tomorrow that starts at 12:00am then SOMETHING MUST BE WRONG! >:O
                // We know that if the current anticipated closing time is 11:59, but the next day the service starts at 12:00am
                // then we can assume it's actually open until the next day at like 1:00am or something...
                // FIRSTLY We check if tomorrow the service will clost at 11:59pm AGAIN -- this actually represents a service that never closes... *AHEM* UPD
                if (tomorrowEndHour == 23 && tomorrowEndMinute == 59) {
                  statusText = "Always Open, Always There for You :)";
                } else {
                nextClosingTime = DateFormat('h:mm').format(tomorrowHourSlots.end)+DateFormat('a').format(tomorrowHourSlots.end).toLowerCase(); // we reassign the variable                
                statusText = "Open until $nextClosingTime";   // this will simply say "2:00am" but college student should be able to recognize that this is the NEXT DAY duh...
                isClosed = false;
                //print("TOMORROW MORNING OPEN");
                //print(nextClosingTime);
                }
              } else {
                // If there are no hour slots tomorrow that start at 12:00am, then we can assume that the service will close at midnight.
                statusText = "Open until midnight";
                isClosed = false;
                //print("TOMORROW NOT IN MORNING");
              }
            }
          } else {
          statusText = "Open until midnight";
          isClosed = false;
          }
        } else {
        statusText = "Open until $nextClosingTime";
        //return "Open until $nextClosingTime";
        isClosed = false;
        }
      } else {
        //return "Closed";
        // Currently, we are not in a 'slot', but what we can do is loop through the hourSlots again to 
        statusText = "Closed";
        isClosed = true;
      }
    }
  } else {  // If there are no HourSlots in a day, we know that the service is closed on that day.
    if (serviceHours.incomingDays[0].holidayName=="") { 
    //return "Closed";
    statusText = "Closed";
    isClosed = true;
    } else {
    //return "Closed: ${serviceHours.incomingDays[0].holidayName}";
    statusText = "Closed: ${serviceHours.incomingDays[0].holidayName}";
    isClosed = true;
    }
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.lens,
        size: 10.0,
        color: isClosed ? Colors.redAccent: Colors.lightGreen,
      ),
      SizedBox(
        width: 1
      ),
      Expanded(
        flex: 1,
        child: AutoSizeText(
          statusText,
          maxLines: 1,
          textAlign: TextAlign.left,
          maxFontSize: AppTheme.cardDescriptionTextSize.max,
          minFontSize: AppTheme.cardDescriptionTextSize.min,
          style: TextStyle(
            color: isClosed? Colors.redAccent: Colors.lightGreen,
            fontWeight: FontWeight.w700,
            fontFamily: 'Roboto'
          )
        )
      )
    ],
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
