import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jackshub/src/sign_in.dart';
import 'package:jackshub/src/wrapper.dart';
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

var signInHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new SignIn();
  }
);

var wrapperHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new Wrapper();
  }
);