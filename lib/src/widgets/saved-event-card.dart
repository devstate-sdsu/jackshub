import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'favorite-widget.dart';


class SavedEventCard extends StatelessWidget {
  SavedEventCard({
    this.name,
    this.img,
    this.height = 120,
    this.docId
  });

  final String name;
  final String img;
  final String docId;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Align(
              child: Container(
                height: this.height,
                width: this.height,
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 5)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)
                      ),
                      child: Image(
                        image: Image.network(this.img).image,
                        fit: BoxFit.fitWidth,
                        height: this.height *.8,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                      ),
                      child: AutoSizeText(
                        this.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Hobo',
                          fontSize: 35,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        );
  }
}
