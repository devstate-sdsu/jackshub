import 'package:flutter/material.dart';

class Card_MenuPicture extends StatelessWidget {
  Card_MenuPicture({
    this.title,
    this.description,
    this.img,
  });

  final String title;
  final String description;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(this.title),
              
            ],
          ),
        ),
      ),
    );
  }
}