//import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/index.dart';



class Routes {
  static final String home = '/';
  static final String servicesDetail = '/detailedServices';

  Route<dynamic> Function(RouteSettings) routes = (settings) {
    if (settings.name == home) {
      return PageTransition(
        child: HomeScreen(),
        type: PageTransitionType.fade,
        settings: settings,
      );
    } else if (settings.name == servicesDetail) {
      return PageTransition(
        child: RouteToDetailedServices(),
        type: PageTransitionType.downToUp,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
        settings: settings,
      );
    } else {
      return null;
    }
  };



  /*Route<dynamic> Function(RouteSettings settings) {
    switch (settings.name) {
      case '/detailedServices':
        return PageTransition(
          child: DetailedServicesScreen(),
          type: PageTransitionType.downToUp,
          settings: settings,
        );
      default:
        return null;
    }
  }*/
}


/*
class Routes {
  Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    '/': (context) => HomeScreen(),
    '/detailedServices': (context) => RouteToDetailedServices(),
  };
}
*/


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












// These are the routes that exist in the app. 'Routes' can be thought
// of as the screens that the user may see while navigating in the app.
/*class Routes {

  //static String services = "detailedServices";

  static void configureRoutes(Router router) {

    router.define("/", handler: rootHandler);
    /*
    router.define("/detailedEvents/:docId", handler: detailedEventsHandler);
    router.define("/detailedFood/:docId", handler: detailedFoodHandler);*/
    //outer.define("detailedServices/:docId/:name/:image", handler: detailedServicesHandler);
    router.define(
      'detailedServices/:paramdata',
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String docId = params['docId']?.first;
          String name = params['name']?.first;
          //String image = params['image']?.first;
          return DetailedServicesScreen(
            docId: docId,
            name: name,
            //image: image
          );
        }
      )
    );

  }
}
*/



// When the router service is told to 'route' the user to a screen,
// these 'handlers' will determine what happens. 
/*
var rootHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new HomeScreen();
});
*/

/*
var detailedFoodHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return DetailedFoodScreen(docId: params["docId"][0]);
});

var detailedEventsHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return DetailedEventsScreen(docId: params["docId"][0]);
});
*/

/*
var detailedServicesHandler = new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print("PARAMS[DOCID][0]");
  print(params["docId"][0]);
  print("PARAMS[NAME][0]");
  print(params["name"][0]);
  print("PARAMS[IMAGE][0]");
  print(params["image"][0]);
  return DetailedServicesScreen(
    docId: params["docId"][0], 
    name: params["name"][0], 
    image: params["image"][0],
  );
});
*/


// This is the main important 'router' class for the app.
// It is used by the app to enable routing between different screens.
// The router is actually initialized in app_component.dart.
/*
class ApplicationRouter {
  static Router router;
}
*/

