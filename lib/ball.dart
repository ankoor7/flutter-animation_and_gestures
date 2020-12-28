import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double diameter = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.amber[400],
        shape: BoxShape.circle,
      )
    );
  }
}
