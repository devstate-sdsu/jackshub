import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'widgets/menu-card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Jacks Hub'),
      ),
      body: ListView(
        children: <Widget>[
          Text('cards go here!')
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
      ),
    );
  }
}
