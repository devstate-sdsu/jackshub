import 'package:flutter/material.dart';
import 'package:jackshub/src/home_screen.dart';
import 'package:jackshub/src/models/user.dart';
import 'package:provider/provider.dart';
import 'package:jackshub/src/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}