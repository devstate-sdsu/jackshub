import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:jackshub/widgets/index.dart';
import 'package:jackshub/config/theme.dart';



class DetailedEventsScreen extends StatelessWidget{
  DetailedEventsScreen({
    this.docId,
    this.name,
    this.image,
  });

  final String docId;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          )
        ),
        Hero(
          tag: 'eventsCardImg'+this.docId,
          
        ),
        ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              )
            ),
            Row(
              children: <Widget>[

              ],
            )
          ]
        )
      ],
    );
  }
}