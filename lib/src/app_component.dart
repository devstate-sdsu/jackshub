import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:jackshub/src/models/user.dart';
import 'package:jackshub/src/services/auth.dart';
import '../config/application.dart';
import '../config/routes.dart';
import 'package:provider/provider.dart';

class AppComponent extends StatefulWidget {
  @override
  State createState() {
    return new _AppComponent();
  }
}

class _AppComponent extends State<AppComponent> {
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
