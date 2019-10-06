import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
          icon: (_isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
          color: Colors.red,
          onPressed: _toggleFavorite,
        );
  }
}
