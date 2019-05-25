import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'widgets/card_menu_picture.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Jacks Hub'),
      ),
      body: Center(
        child: CardMenuPicture(
          title: 'biiiitch',
          description: 'what a biiitch',
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
      ),
    );
  }
}

