import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Color color;
  final double size;
  final double circleWidth;
  final Text txt;

  const CircleButton(
      {Key key, this.color, this.size, this.circleWidth, this.txt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        width: size,
        height: size,
        decoration: new BoxDecoration(
          border: Border.all(
            style: BorderStyle.solid,
            color: color,
            width: circleWidth,
          ),
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: new Center(child: txt),
      ),
    );
  }
}
