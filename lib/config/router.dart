import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/util/database_helpers.dart';
import '../screens/index.dart';
import 'package:jackshub/util/date-time-helper.dart';



class Routes {
  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    '/': (context) => SplashScreen(),
    '/detailedServices': (context) => RouteToDetailedServices(),
    '/detailedEvents' : (context) => RouteToDetailedEvents(),
  };
}



class ServicesRoutingParameters {
  final DocumentSnapshot doc;
  final String name;
  final String image;
  final String mainInfo;
  final String bigLocation;
  final String littleLocation;
  final String email;
  final String phoneNumber;
  final ServiceHours serviceHours;
  ServicesRoutingParameters(this.doc, this.name, this.image, this.mainInfo, this.bigLocation, this.littleLocation, this.email, this.phoneNumber, this.serviceHours);
}

class RouteToDetailedServices extends StatelessWidget {
  //static const routeName = '/detailedServices';       DEPRECATED
  @override
  Widget build(BuildContext context) {
    final ServicesRoutingParameters parameters = ModalRoute.of(context).settings.arguments;
    return DetailedServicesScreen(doc: parameters.doc, name: parameters.name, image: parameters.image, mainInfo: parameters.mainInfo, bigLocation: parameters.bigLocation, littleLocation: parameters.littleLocation, email: parameters.email, phoneNumber: parameters.phoneNumber, serviceHours: parameters.serviceHours);
  }

}



class EventsRoutingParameters {
  final EventInfo event;
  final BuildContext blocContext;
  EventsRoutingParameters({this.event, this.blocContext});
}

class RouteToDetailedEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventsRoutingParameters parameters = ModalRoute.of(context).settings.arguments;
    return DetailedEventsScreen(event: parameters.event, blocContext: parameters.blocContext);
  }
}






/*  NEED TO BE LOOKED INTO
class FadeTransitionRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  FadeTransitionRoute({this.exitPage, this.enterPage}) : super (
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => enterPage,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => Stack(
      children: <Widget>[
        FadeTransition(
          opacity: animation,
          child: child
        )
      ],
    )
  );
}
*/