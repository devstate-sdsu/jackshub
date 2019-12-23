import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/config/router.dart';



class App extends StatefulWidget {
  @override
  State createState() {
    return new _App();
  }
}



class _App extends State<App> {
  _App() {
    final router = new Router();
    Routes.configureRoutes(router);
    ApplicationRouter.router = router;
  }
  
  @override
  Widget build(BuildContext context) {
    final app = new MaterialApp(
      title: 'JacksHub',
      debugShowCheckedModeBanner: false,

      theme: lightTheme,
      darkTheme: darkTheme,

      onGenerateRoute: ApplicationRouter.router.generator,
    );
    return app;
  }
}
