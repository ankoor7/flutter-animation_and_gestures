import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  Bat(this.width, this.height);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.blue[900],
    );
  }
}
