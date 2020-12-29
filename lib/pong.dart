import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_pong/ball.dart';
import 'package:simple_pong/bat.dart';

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double width;
  double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  double increment = 5;
  static final Random random = Random();
  double xMultiplier = 1;
  double yMultiplier = 1;
  int score = 0;

  Ball ball = Ball();

  Animation<double> animation;
  AnimationController controller;
  double tweenMaxValue = 100;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: tweenMaxValue).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += (increment + xMultiplier).round()
            : posX -= (increment + xMultiplier).round();
        (vDir == Direction.down)
            ? posY += (increment + yMultiplier).round()
            : posY -= (increment + yMultiplier).round();
      });
      checkBorders();
    });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: <Widget>[
            Positioned(
              child: Text("Score: $score"),
              top: 0,
              right: 24,
            ),
            Positioned(
              child: ball,
              left: posX,
              top: posY,
            ),
            Positioned(
                left: batPosition,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: moveBat,
                  child: Bat(batWidth, batHeight),
                )),
          ],
        );
      },
    );
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  // Pong Logic
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      xMultiplier = randomNumber();
    }
    if (width != null && posX >= width - ball.diameter && hDir == Direction.right) {
      hDir = Direction.left;
      xMultiplier = randomNumber();
    }
    if (height != null && posY >= height - ball.diameter - batHeight && vDir == Direction.down) {
      // check if bat is under the ball
      if (posX >= (batPosition - ball.diameter) && posX <= (batPosition + batWidth + ball.diameter)) {
        vDir = Direction.up;
        yMultiplier = randomNumber();
        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      yMultiplier = randomNumber();
    }
  }

  double randomNumber() => ((tweenMaxValue.toInt() / 2) + random.nextInt(tweenMaxValue.toInt() + 1)) / tweenMaxValue;

  void showMessage(BuildContext context) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Would you like to play again?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                });
                Navigator.of(context).pop();
                controller.repeat();
              },
              child: Text('Yes'),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
                child: Text('No'),
            )
          ],
        );
      }
    );
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(function);
    }
  }
}

enum Direction { up, down, left, right }
