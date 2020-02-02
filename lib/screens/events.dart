import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jackshub/config/theme.dart';
import 'package:jackshub/screens/index.dart';
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
    Icons.directions_run,
    Icons.favorite,
  ];
  List _filters = [
    'All',
    'Sports',
    'Favorites',
  ];
  Color _foregroundOn = Colors.white;
  Color _foregroundOff = Colors.black;
  Color _backgroundOn = Colors.black;
  Color _backgroundOff = Colors.grey[300];
  ScrollController _scrollController = new ScrollController();
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
  List <Widget> screens = 
  [
    EventsScreen(),
    SavedEvents(),
  ];

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    return Column(children: <Widget>[
          Flexible(
              // this will host our Tab Views
              child: TabBarView(
            // and it is controlled by the controller
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: <Widget>[
              EventsScreen(),
              SavedEvents(),
              EventsScreen()
            ],
          )),
          // this is the TabBar
          Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: AppTheme.shadowBlurRadius,
                    offset: AppTheme.shadowOffset
                  )
                ],
              ),
              height: 70.0,
              // this generates our tabs buttons
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                child: ListView.builder(
                    // this gives the TabBar a bounce effect when scrolling farther than it's size
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    // make the list horizontal
                    scrollDirection: Axis.horizontal,
                    // number of tabs
                    itemCount: _icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          // each button's key
                          key: _keys[index],
                          // padding for the buttons
                          padding: EdgeInsets.all(6.0),
                          child: ButtonTheme(
                              child: AnimatedBuilder(
                            animation: _colorTweenBackgroundOn,
                            builder: (context, child) => FlatButton(
                                // get the color of the button's background (dependent of its state)
                                color: _getBackgroundColor(index),
                                // make the button a rectangle with round corners
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(7.0)),
                                onPressed: () {
                                  setState(() {
                                    _buttonTap = true;
                                    // trigger the controller to change between Tab Views
                                    _controller.animateTo(index);
                                    // set the current index
                                    _setCurrentIndex(index);
                                    // scroll to the tapped button (needed if we tap the active button and it's not on its position)
                                    _scrollTo(index);
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                        Icon(
                                          // get the icon
                                          _icons[index],
                                          // get the color of the icon (dependent of its state)
                                          color: _getForegroundColor(index),
                                        ),
                                    // Flexible(
                                    //   flex: 3,
                                    //   child: Text(
                                    //     _filters[index],
                                    //     style: TextStyle(
                                    //       color: _getForegroundColor(index),
                                    //       fontWeight: FontWeight.w600,
                                    //       fontFamily: 'Roboto'
                                    //     )
                                    //   )
                                    // )
                                  ],
                                )
                                ),
                          )));
                    }),
              )),
        ]);
    // return Column(
    //   children: <Widget>[
    //     Padding(
    //       padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
    //       child: CupertinoSegmentedControl(
    //         groupValue: selectedScreenIdx,
    //         onValueChanged: (screenIdx){
    //           setState(() {
    //             selectedScreenIdx = screenIdx;
    //           });
    //         }, 
    //         children: selectionTexts,
    //       ),
    //     ),
    //     Expanded(child: screens[selectedScreenIdx]),
    //   ],
    // );
  }

  // runs during the switching tabs animation
  _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = _controller.animation.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) _setCurrentIndex(_controller.index);

    // this resets the button tap
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    // save the previous controller index
    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });

      // trigger the button animation
      _triggerAnimation();
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    // reset the animations so they're ready to go
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    // run the animations!
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    double screenWidth = MediaQuery.of(context).size.width;

    // get the button we want to scroll to
    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    // get its size
    double size = renderBox.size.width;
    // and position
    double position = renderBox.localToGlobal(Offset.zero).dx;
    
    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    double offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = _keys[0].currentContext.findRenderObject();
      // get the position of the first button of the TabBar
      position = renderBox.localToGlobal(Offset.zero).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (position > offset) offset = position;
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = _keys[_icons.length - 1].currentContext.findRenderObject();
      // get its position
      position = renderBox.localToGlobal(Offset.zero).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) screenWidth = position + size;

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    // scroll the calculated ammount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: new Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      // if it's active button
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      // if it's the previous active button
      return _colorTweenBackgroundOff.value;
    } else {
      // if the button is inactive
      return _backgroundOff;
    }
  }

  _getForegroundColor(int index) {
    // the same as the above
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsBloc, SavedEventsState>(
      builder: (context, state) {
        if (state is SavedEventsIdsLoaded || state is SavedEventsInfoLoaded) {
          Map ultimateDocIds = state.savedEventsIdsMap;
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('eventsCol').orderBy('start_time').snapshots(),
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
        return Container(
          child: Text("Loading")
        );
      },
    );
    
   
  }

  static Widget buildEventsListItem(DocumentSnapshot doc, bool favorite) {
    //String imageurl = doc['image'];   DEPRECATED
    String titlename = doc['name'];
    if (
      //imageurl.contains("teaser") || 
      titlename.contains("Basketball") ||
      titlename.contains("basketball") ||
      titlename.contains("College of") ||
      titlename.contains("Wrestling") ||
      titlename.contains("Track") ||
      titlename.contains("Preview") ||
      titlename.contains("Theatre")
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
