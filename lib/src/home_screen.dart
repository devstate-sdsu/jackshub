import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Jacks Hub'),
      ),
      body: Center(
        child: Text('Hello World!'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
      ),
    );
  }
}