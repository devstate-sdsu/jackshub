import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/index.dart';



class Routes {
  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    '/': (context) => SplashScreen(),
    '/detailedServices': (context) => RouteToDetailedServices(),
    '/detailedEvents' : (context) => RouteToDetailedEvents(),
  };
}



class ServicesRoutingParameters {
  final String name;
  final String image;
  final String docId;
  ServicesRoutingParameters(this.name, this.image, this.docId);
}

class RouteToDetailedServices extends StatelessWidget {
  //static const routeName = '/detailedServices';

  @override
  Widget build(BuildContext context) {
    final ServicesRoutingParameters parameters = ModalRoute.of(context).settings.arguments;
    return DetailedServicesScreen(docId: parameters.docId, name: parameters.name, image: parameters.image);
  }

}


class EventsRoutingParameters {
  final String docId;
  final String name;
  final String image;
  final String description;
  final String bigLocation;
  final String littleLocation;
  final Timestamp startTime;
  final Timestamp endTime;
  EventsRoutingParameters(this.docId, this.name, this.image, this.description, this.bigLocation, this.littleLocation, this.startTime, this.endTime);
}

class RouteToDetailedEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventsRoutingParameters parameters = ModalRoute.of(context).settings.arguments;
    return DetailedEventsScreen(docId: parameters.docId, name: parameters.name, image: parameters.image, description: parameters.description, bigLocation: parameters.bigLocation, littleLocation: parameters.littleLocation, startTime: parameters.startTime, endTime: parameters.endTime);
  }
}