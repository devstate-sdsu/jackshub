import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../src/home_screen.dart';

var rootHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new HomeScreen();
  }
);

var pageEventsHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new HomeScreen();
  }
);

var pageServicesHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new HomeScreen();
  }
);

var pageFoodHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new HomeScreen();
  }
);
