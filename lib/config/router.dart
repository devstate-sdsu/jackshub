import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../screens/index.dart';



// These are the routes that exist in the app. 'Routes' can be thought
// of as the screens that the user may see while navigating in the app.
class Routes {
  static void configureRoutes(Router router) {

    router.define("/", handler: rootHandler);
    /*
    router.define("/detailedEvents/:docId", handler: detailedEventsHandler);
    router.define("/detailedFood/:docId", handler: detailedFoodHandler);
    router.define("/detailedServices/:docId", handler: detailedServicesHandler);
    */
  }
}



// When the router service is told to 'route' the user to a screen,
// these 'handlers' will determine what happens. 
var rootHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new HomeScreen();
});

/*
var detailedFoodHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return DetailedFoodScreen(docId: params["docId"][0]);
});

var detailedEventsHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return DetailedEventsScreen(docId: params["docId"][0]);
});

var detailedServicesHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return DetailedServicesScreen(docId: params["docId"][0]);
});
*/


// This is the main important 'router' class for the app.
// It is used by the app to enable routing between different screens.
// The router is actually initialized in app_component.dart.
class ApplicationRouter {
  static Router router;
}

