import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard({
    this.title,
    this.description,
    this.img,
    this.height = 400
  });

  final Text title;
  final Text description;
  final Image img;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: this.height,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [ 
            BoxShadow(
              color: Colors.black26,
              blurRadius: 50,
              offset: Offset(0, 5)
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              ),
              child: Container(
                height: this.height *.8,
                width: double.infinity,
                child: this.img,
              ),
            ),
            ListTile(
              title: this.title,
              subtitle: this.description,
            )
          ],
        ),
      ));
  }
}