import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:jackshub/src/models/user.dart';
import 'package:jackshub/src/services/auth.dart';
import 'package:jackshub/config/application.dart';
import 'package:jackshub/config/routes.dart';
import 'package:provider/provider.dart';

class AppComponent extends StatefulWidget {
  @override
  State createState() {
    return new _AppComponent();
  }
}

class _AppComponent extends State<AppComponent> {

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('>>> DEEP LINK PATH: ');
      print(deepLink.path);
      Navigator.pushNamed(context, Routes.sign_in);
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          Navigator.pushNamed(context, deepLink.path);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
  }
  
  _AppComponent() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  
  @override
  Widget build(BuildContext context) {
    final app = StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'JacksHub',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.wrapper,
        theme: new ThemeData(
          //primarySwatch: Colors.white,
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
          fontFamily: 'Montserrat',

          textTheme: TextTheme(
            headline: TextStyle(fontSize: 64.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal),
            body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          ),

          appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.black),
            )
          )
        ),
        onGenerateRoute: Application.router.generator,
      ),
    );
    return app;
  }
}
