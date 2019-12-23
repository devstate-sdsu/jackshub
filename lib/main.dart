import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';

void main() {
  // Forces portrait orientation on devices.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  // Set the system status bar color to white with black text, and remove the default
  // Flutter Material AppBar at the top.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0x00FFFFFF)));
  
  // Actually run the app, Located in app.dart.
  runApp(new App());
}







//class Item {
//  String key;
//  String title;
//  String body;
//
//  Item(this.title, this.body);
//
//  Item.fromSnapshot(DataSnapshot snapshot)
//    : key = snapshot.key
//      title = snapshot.value["title"],
//      body = snapshot.value["body"];
//
//  toJson() {
//    return {
//      "title": title,
//      "body": body,
//    };
//  }
//}
