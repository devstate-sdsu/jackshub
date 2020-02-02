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
          //physics: const NeverScrollableScrollPhysics(),
          //shrinkWrap: true,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 120,
              child: AutoSizeText(
                bigLocation,
                maxLines: 1,
                maxFontSize: AppTheme.bigLocationTextSize.max,
                minFontSize: AppTheme.bigLocationTextSize.min,
                style: Theme.of(context).textTheme.display3
              ),
            ),
            Spacer(
              flex: 5
            ),
            Visibility(
              visible: littleLocation != "",
              child: Flexible(
                flex: 80,
                child: AutoSizeText(
                  littleLocation,
                  maxLines: 1,
                  maxFontSize: AppTheme.littleLocationTextSize.max,
                  minFontSize: AppTheme.littleLocationTextSize.min,
                  style: Theme.of(context).textTheme.display4
                )
              )
            ),
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
        width: 4.0
      ),
      AutoSizeText(
        dateString,
        maxLines: 1,
        maxFontSize: AppTheme.dateStringTextSize.max,
        minFontSize: AppTheme.dateStringTextSize.min,
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
        width: 4.0
      ),
      Flexible(
        child: AutoSizeText(
          startString + "-" + endString,
          maxLines: 1,
          maxFontSize: AppTheme.timeStringTextSize.max,
          minFontSize: AppTheme.timeStringTextSize.min,
          style: Theme.of(context).textTheme.display2
        )
      )
    ],
  );
}