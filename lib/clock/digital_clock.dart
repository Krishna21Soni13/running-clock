// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the

import 'dart:async';
import 'dart:math';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'hour.dart';
import 'minute.dart';


class DigitalClock extends StatefulWidget {
  DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  Color currentColor;
  Color prevColor;

  AnimationController _animationController;
  Timer timer;
  DateTime _dateTime;
  var animProgress = 0.0;

  @override
  void initState() {
    super.initState();

    currentColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    prevColor = currentColor;
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          animProgress = _animationController.value;
        });
      });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        prevColor = currentColor;
      }
    });
    _updateTime();
  }

  @override
  void dispose() {
    widget.model.dispose();
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      currentColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Initializations of values
    final valueTop = _isPortrait(context) ? 15 : 25;
    final valueTopProgress = _isPortrait(context) ? 8.5 : 8.0;

    // Logic to keep the last element in center
    final boxHeight = _isPortrait(context)
        ? ((MediaQuery.of(context).size.width / 5) * 3)
        : MediaQuery.of(context).size.height;
    final top = _isPortrait(context)
        ? ((boxHeight * valueTop) / 225)
        : (boxHeight * valueTop) / 225;
    final topProgress = (boxHeight * valueTopProgress) / 225;

    final left = _isPortrait(context) ? 20.0 : 40.0;
    final scale = _isPortrait(context) ? 2.0 : 4.0;
    final opacity = 1.0;
    final scaleProgress = _isPortrait(context) ? 0.25 : 0.25;
    final colorIntense = 0.2;

    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      color: Theme.of(context).brightness == Brightness.light
          ? Color.lerp(prevColor, currentColor, animProgress)
          : Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        // Arranging the hour and minute stack
        children: <Widget>[
          HourView(
              widget.model,
              Theme.of(context).brightness == Brightness.light
                  ? Color.lerp(prevColor, currentColor, animProgress)
                  : Colors.black,
              left,
              top,
              scale,
              opacity,
              topProgress,
              scaleProgress,
              colorIntense),
          SizedBox(width: _isPortrait(context) ? 130 : 150),
          MinuteView(
              Theme.of(context).brightness == Brightness.light
                  ? Color.lerp(prevColor, currentColor, animProgress)
                  : Colors.black,
              left,
              top,
              scale,
              opacity,
              topProgress,
              scaleProgress,
              colorIntense),
        ],
      ),
    ));
  }

  // Determines whether in landScape or portrait mode
  static bool _isPortrait(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? true
        : false;
  }
}

/* _controller = AnimationController(
      duration: Duration(minutes: 1) -
          Duration(seconds: DateTime.now().second) -
          Duration(milliseconds: DateTime.now().millisecond),
      vsync: this,
    )..repeat();*/

/*Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red,
        end: Colors.green,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.green,
        end: Colors.red,
      ),
    ),
  ]);
}*/
//Colors.primaries[Random().nextInt(Colors.primaries.length)]
