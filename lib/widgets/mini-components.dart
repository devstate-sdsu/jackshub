import 'package:flutter/material.dart';
import 'package:jackshub/config/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget locationComponent(context, bigLocation, littleLocation) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.location_on,
        size: 18.0,
        color: Theme.of(context).accentColor
      ),
      SizedBox(
        width: 1.0
      ),
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              bigLocation,
              maxLines: 2,
              maxFontSize: AppTheme.bigLocationTextSize,
              style: Theme.of(context).textTheme.display3
            ),
            SizedBox(
              height: 2.0
            ),
            Visibility(
              visible: littleLocation != "",
              child: AutoSizeText(
                littleLocation,
                maxLines: 2,
                maxFontSize: AppTheme.littleLocationTextSize,
                style: Theme.of(context).textTheme.display4
              )
            )
          ],
        )
      ),
      SizedBox(
        width: 2.0
      )
    ],
  );
}

Widget dateComponent(context, dateString) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.calendar_today,
        size: 14,
        color: Theme.of(context).accentColor
      ),
      SizedBox(
        width: 5.0
      ),
      AutoSizeText(
        dateString,
        maxLines: 1,
        maxFontSize: AppTheme.dateStringTextSize,
        style: Theme.of(context).textTheme.display2
      )
    ],
  );
}

Widget timeComponent(context, startString, endString) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.schedule,
        size: 13.5,
        color: Theme.of(context).accentColor
      ),
      SizedBox(
        width: 5.0
      ),
      Flexible(
        child: AutoSizeText(
          startString + "-" + endString,
          maxLines: 1,
          maxFontSize: AppTheme.timeStringTextSize,
          style: Theme.of(context).textTheme.display2
        )
      )
    ],
  );
}