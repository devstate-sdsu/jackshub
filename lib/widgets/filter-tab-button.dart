import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jackshub/config/theme.dart';

import 'package:jackshub/src/blocs/filter_tabs/filter_tabs_bloc.dart';
import 'package:jackshub/src/blocs/events_scroll/events_scroll_bloc.dart';

class FilterTabButton extends StatefulWidget {
  final FilterTabsBloc filterTabsBloc;
  final EventsScrollBloc eventsScrollBloc;
  final int tabIndex;
  final List filterIcons;
  final List filterDisplayNames;
  
  const FilterTabButton({
    Key key,
    this.filterTabsBloc,
    this.eventsScrollBloc,
    this.tabIndex,
    this.filterIcons,
    this.filterDisplayNames
  }): super(key: key);

  @override
  _FilterTabButton createState() => _FilterTabButton();
}

class _FilterTabButton extends State<FilterTabButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  var scale = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: AppTheme.cardAnimateDuration
      )
    );
    _animation = Tween(
      begin: 1.0,
      end: AppTheme.cardTouchedScale*0.9
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.cardForwardCurve,
        reverseCurve: AppTheme.cardReverseCurve
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            _controller.forward();
          },
          onTapUp: (TapUpDetails details) {
            _controller.forward();
            widget.filterTabsBloc.add(SelectFilterTab(tabIndex: widget.tabIndex));
            widget.eventsScrollBloc.add(TabSelected());
            Timer(
              Duration(milliseconds: 250),
              () => _controller.reverse()
            );
          },
          onTapCancel: () {
            _controller.reverse();
          },
          child: Transform.scale(
            scale: _animation.value,
            child: Container(
              margin: EdgeInsets.fromLTRB(screenWidth * AppTheme.filterTabsSpacerPercent, 0.0, screenWidth * AppTheme.filterTabsSpacerPercent, 0.0),
              height: screenWidth * AppTheme.filterTabsHeightPercent,
              width: screenWidth * AppTheme.filterTabsWidthPercent,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(screenWidth * AppTheme.filterTabsBorderRadiusPercent)
                ),
                color: Theme.of(context).indicatorColor,
                boxShadow: [BoxShadow(
                  color: (Theme.of(context).brightness == Brightness.light) ? AppTheme.lightShadowColor: AppTheme.darkShadowColor,
                  blurRadius: AppTheme.shadowBlurRadius,
                  offset: AppTheme.shadowOffset
                )]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        widget.filterIcons[widget.tabIndex],
                        color: Theme.of(context).backgroundColor,
                        size: screenWidth * AppTheme.filterTabsIconSizePercent
                      )
                    ),
                    Expanded(
                      child: Text(
                        widget.filterDisplayNames[widget.tabIndex],
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: screenWidth * AppTheme.filterTabsTextSizePercent
                        )
                      )
                    )
                  ],
                )
              )
            )
          )
        );
      }
    );
  }
}