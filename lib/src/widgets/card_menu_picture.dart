import 'package:flutter/material.dart';

class CardMenuPicture extends StatelessWidget {
  CardMenuPicture({
    this.title,
    this.description,
    this.img,
  });

  final String title;
  final String description;
  final String img;
  final double height = 400;

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: Card(
      //   semanticContainer: true,
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //   clipBehavior: Clip.antiAliasWithSaveLayer,
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
                child: Image.network(
                  'https://scontent.ffsd1-1.fna.fbcdn.net/v/t1.0-9/21463316_1926088534320469_5351309309476864102_n.jpg?_nc_cat=103&_nc_ht=scontent.ffsd1-1.fna&oh=1541f36b0814eb09a5a8e59c935473e4&oe=5D65FF3E',
                  height: this.height * .8,
                  width: double.infinity,
                  fit: BoxFit.fill ,
                ),
              ),
              ListTile(
                title: Text(this.title),
                subtitle: Text(this.description),
              )
            ],
          ),
        ));
    //   ),
    // );
  }
}