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
        child: Text('cards will go here')
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
      ),
    );
  }
}

// CardMenuPicture(
//           title: Text('biiiitch'),
//           description: Text('what a biiitch'),
//           img: Image.network(
//             'https://scontent.ffsd1-1.fna.fbcdn.net/v/t1.0-9/21463316_1926088534320469_5351309309476864102_n.jpg?_nc_cat=103&_nc_ht=scontent.ffsd1-1.fna&oh=1541f36b0814eb09a5a8e59c935473e4&oe=5D65FF3E',
//             fit: BoxFit.fill
//           ),
//         ),

