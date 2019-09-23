import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app_component.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0x00FFFFFF)));
  runApp(new AppComponent());
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
