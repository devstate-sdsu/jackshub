import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventsMenuCard extends StatelessWidget {
  EventsMenuCard({
    this.title,
    this.description,
    this.img,
    this.height = 401
  });

  final String title;
  final String description;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                ),
                child: Image(
                  image: this.img.image,
                  fit: BoxFit.fill,
                  height: this.height *.8,
                  width: double.infinity,
                ),
              ),
              Container(
                color: Colors.amber[600],
                width: 48.0,
                height: 48.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                this.title,
                                textAlign: TextAlign.center
                            ),
                          ),
                          Expanded(
                            child: Text(
                                this.description,
                                textAlign: TextAlign.center
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 24.0,
                      semanticLabel: 'We love hobos',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
