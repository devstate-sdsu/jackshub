import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../config/application.dart';
import '../config/routes.dart';

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
    final app = new MaterialApp(
      title: 'JacksHub',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        //primarySwatch: Colors.white,
      ),
      onGenerateRoute: Application.router.generator,
    );
    return app;
  }
}
