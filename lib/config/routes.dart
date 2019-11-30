import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String page_events = "/events";
  static String page_services = "/services";
  static String page_food = "/food";
  static String sign_in = "/sign-in";
  static String wrapper = "/wrapper";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print("Route not found.");
      }
    );
    router.define(root, handler: rootHandler);
    router.define(page_events, handler: pageEventsHandler);
    router.define(page_services, handler: pageServicesHandler);
    router.define(page_food, handler: pageFoodHandler);
    router.define(sign_in, handler: signInHandler);
    router.define(wrapper, handler: wrapperHandler);
  }
}

