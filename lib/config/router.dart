import 'package:flutter/material.dart';
import '../screens/index.dart';



class Routes {
  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    '/': (context) => HomeScreen(),
    '/detailedServices': (context) => RouteToDetailedServices(),
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