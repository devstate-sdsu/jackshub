import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/src/bloc/index.dart';
import 'package:jackshub/widgets/ColorLoader.dart';
import 'package:jackshub/widgets/index.dart';
import 'package:jackshub/widgets/saved-events.dart';


class EventsToggle extends StatefulWidget {
  @override
  _EventsToggleState createState() => _EventsToggleState();
}

class _EventsToggleState extends State<EventsToggle> with TickerProviderStateMixin {
  TabController _controller;
  AnimationController _animationControllerOn;
  AnimationController _animationControllerOff;
  Animation _colorTweenBackgroundOn;
  Animation _colorTweenBackgroundOff;
  Animation _colorTweenForegroundOn;
  Animation _colorTweenForegroundOff;
  int _currentIndex = 0;
  int _prevControllerIndex = 0;
  double _aniValue = 0.0;
  double _prevAniValue = 0.0;
  List _icons = [
    Icons.zoom_out_map,
    Icons.group,
    Icons.directions_run,
    Icons.favorite,
  ];
  List<Widget> _screens = 
  [
    EventsScreen(filter: 'all'),
    EventsScreen(filter: 'clubs'),
    EventsScreen(filter: 'sporting'),
    SavedEvents(),
  ];
  Color _foregroundOn = Colors.white;
  Color _foregroundOff = Colors.black;
  Color _backgroundOn = Colors.black;
  Color _backgroundOff = Colors.grey[300];
  ScrollController _scrollController = new ScrollController();
  ScrollController _verticalScrollController = new ScrollController();
  bool upDirection = true, flag = true;
  double fabOpacity = 1.0;

  List _keys = [];
  bool _buttonTap = false;
  int selectedScreenIdx = 0;
  final Map<int, Widget> selectionTexts = const<int, Widget> {
    0: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text("All"),
        ), 
    1: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text("Saved"),
        ), 
  };

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < _icons.length; index++) {
      _keys.add(new GlobalKey());
    }

    _controller = TabController(vsync: this, length: _icons.length);
    _controller.animation.addListener(_handleTabAnimation);
    _controller.addListener(_handleTabChange);

    _animationControllerOff =
        AnimationController(vsync: this, duration: Duration(milliseconds: 75));
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff =
        ColorTween(begin: _backgroundOn, end: _backgroundOff)
            .animate(_animationControllerOff);
    _colorTweenForegroundOff =
        ColorTween(begin: _foregroundOn, end: _foregroundOff)
            .animate(_animationControllerOff);

    _animationControllerOn =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
    _colorTweenForegroundOn =
        ColorTween(begin: _foregroundOff, end: _foregroundOn)
            .animate(_animationControllerOn);

    _verticalScrollController..addListener(() {
      upDirection = _verticalScrollController.position.userScrollDirection == ScrollDirection.forward;
      if (upDirection != flag) {
        setState(() {});
      }
      flag = upDirection;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[          
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: _screens,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
                color: Colors.transparent.withOpacity(0),
                height: 70.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _icons.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            key: _keys[index],
                            padding: EdgeInsets.all(6.0),
                            child: ButtonTheme(
                                child: AnimatedBuilder(
                              animation: _colorTweenBackgroundOn,
                              builder: (context, child) => FlatButton(
                                  color: _getBackgroundColor(index),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(7.0)),
                                  onPressed: () {
                                    setState(() {
                                      _buttonTap = true;
                                      _controller.animateTo(index);
                                      _setCurrentIndex(index);
                                      _scrollTo(index);
                                    });
                                  },
                                  child: Icon(
                                    _icons[index],
                                    color: _getForegroundColor(index),
                                  ),
                                ),
                            )));
                      }),
                )),
          ),
        ]);
  }

  _handleTabAnimation() {
    _aniValue = _controller.animation.value;
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      _setCurrentIndex(_aniValue.round());
    }
    _prevAniValue = _aniValue;
  }
  _handleTabChange() {
    if (_buttonTap) _setCurrentIndex(_controller.index);
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;
    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _triggerAnimation();
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    _animationControllerOn.reset();
    _animationControllerOff.reset();
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(Offset.zero).dx;
    double offset = (position + size / 2) - screenWidth / 2;
    if (offset < 0) {
      renderBox = _keys[0].currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;
      if (position > offset) offset = position;
    } else {
      renderBox = _keys[_icons.length - 1].currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;
      size = renderBox.size.width;
      if (position + size < screenWidth) screenWidth = position + size;
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: new Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenBackgroundOff.value;
    } else {
      return _backgroundOff;
    }
  }

  _getForegroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return _foregroundOff;
    }
  }
}

class EventsScreen extends StatelessWidget {
  final String filter;
  EventsScreen({this.filter});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsIdsLoaded || state is SavedEventsInfoLoaded) {
          Map ultimateDocIds = state.savedEventsIdsMap;
          return StreamBuilder<QuerySnapshot>(
            stream: this.filter == 'all' ? 
              Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots() :
              Firestore.instance.collection('eventsCol').where('tags', arrayContains: this.filter).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: ColorLoader5()
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  bool favorite = ultimateDocIds.containsKey(snapshot.data.documents[index].documentID);
                  return buildEventsListItem(snapshot.data.documents[index], favorite);
                }
              );
            }
          ); 
        }
        return Center(
          child: ColorLoader5()
        );
      },
    );
    
   
  }

  static Widget buildEventsListItem(DocumentSnapshot doc, bool favorite) {
    //String imageurl = doc['image'];   DEPRECATED
    final tags = doc['tags'];
    if (
      tags.contains('sporting')
      ) {
      return EventsSmallCard(
        name: doc['name'],
        image: doc['image'],
        bigLocation: doc['big_location'],
        littleLocation: doc['tiny_location'],
        startTime: doc['start_time'],
        endTime: doc['end_time'],
        favorite: favorite,
        docId: doc.documentID
      );
    } else {
      return EventsCard(
        name: doc['name'],
        image: doc['image'],
        description: doc['description'],
        //summary: doc['summary'],   DEPRECATED
        bigLocation: doc['big_location'],
        littleLocation: doc['tiny_location'],
        startTime: doc['start_time'],
        endTime: doc['end_time'],
        favorite: favorite,
        docId: doc.documentID
      );
    }
  }
}
