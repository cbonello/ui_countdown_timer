import 'package:flutter/material.dart';
import 'package:ui_countdown_timer/utils/pantograph.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    Key key,
    @required this.size,
    @required this.animation,
    this.onPressed,
  }) : super(key: key);

  final double size;
  final Animation<double> animation;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(height: size, width: size),
      shape: const CircleBorder(),
      elevation: Pantograph.of(context).platformValue(1.0, 0.0),
      fillColor: const Color(0xFF9DCBCE),
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          print(animation.value);
          return Transform.rotate(
            angle: animation.value,
            child: Icon(
              Icons.add,
              size: Pantograph.of(context).scaledHeight(90.0),
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
