import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_countdown_timer/bloc/timer/bloc.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({
    Key key,
    this.angle,
    this.hOffset,
    this.dialDiameter,
    this.knobDiameter1,
    this.knobDiameter2,
  }) : super(key: key);

  final double angle, hOffset, dialDiameter, knobDiameter1, knobDiameter2;

  // Offset _rotate(Offset center, Offset pt, double angle) {
  //   final double xM = pt.dx - center.dx;
  //   final double yM = pt.dy - center.dy;
  //   final double x = xM * math.cos(angle) + yM * math.sin(angle) + center.dx;
  //   final double y = -xM * math.sin(angle) + yM * math.cos(angle) + center.dy;
  //   return Offset(x, y);
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.expand,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all((knobDiameter2 - knobDiameter1) / 2.0),
          child: CustomPaint(
            painter: _BackgroundPainter(
              angle: angle,
              knobDiameter1: knobDiameter1,
            ),
            child: Container(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all((knobDiameter2 - dialDiameter) / 2.0),
          child: FractionallySizedBox(
            alignment: Alignment.center,
            // Text span on 63% of circle diameter in original design.
            widthFactor: 0.63,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: BlocBuilder<TimerBloc, TimerState>(
                builder: (BuildContext context, TimerState state) {
                  final String hoursStr = ((state.duration / 3600) % 3600)
                      .floor()
                      .toString()
                      .padLeft(2, '0');
                  final String minutesStr = ((state.duration / 60) % 60)
                      .floor()
                      .toString()
                      .padLeft(2, '0');
                  final String secondsStr =
                      (state.duration % 60).floor().toString().padLeft(2, '0');

                  return Text(
                    '$hoursStr:$minutesStr:$secondsStr',
                    style: const TextStyle(
                      color: Color(0xFF50979D),
                      decoration: TextDecoration.none,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    Listenable repaint,
    this.angle,
    this.knobDiameter1,
  }) : super(repaint: repaint);

  final double angle, knobDiameter1;

  // Offset _rotate(double ox, double oy, double mx, double my, double angle) {
  //   final double xm = mx - ox;
  //   final double ym = my - oy;
  //   final double dx = xm * math.cos(angle) + ym * math.sin(angle) + ox;
  //   final double dy = -xm * math.sin(angle) + ym * math.cos(angle) + oy;
  //   return Offset(dx, dy);
  // }

  num degToRad(num deg) => deg * (math.pi / 180.0);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintKnob1 = Paint()
      ..color = Colors.white38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final Paint paintKnob2 = Paint()
      ..color = const Color(0x18FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final Paint paintShadow = Paint()
      ..color = const Color(0x1F000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final double startAngle = degToRad(15.0);

    canvas.drawArc(
      Rect.fromLTWH(-2, -2, knobDiameter1, knobDiameter1),
      angle - startAngle,
      -math.pi + 2 * startAngle,
      false,
      paintShadow,
    );
    canvas.drawOval(
        Rect.fromLTWH(0, 0, knobDiameter1, knobDiameter1), paintKnob2);
    for (double i = 0.0; i < 5.0; i++) {
      canvas.drawArc(
        Rect.fromLTWH(0, i, knobDiameter1, knobDiameter1 - i),
        angle - startAngle,
        -math.pi + 2 * startAngle,
        false,
        paintKnob1,
      );
    }
    final Path path = Path();
    final Offset x1 = Offset(
      knobDiameter1 / 2.0 +
          knobDiameter1 / 2.0 * math.cos(angle - math.pi / 2.0 - degToRad(4.0)),
      knobDiameter1 / 2.0 +
          knobDiameter1 / 2.0 * math.sin(angle - math.pi / 2.0 - degToRad(4.0)),
    );
    final Offset x2 = Offset(
      knobDiameter1 / 2.0 +
          (knobDiameter1 - 15.0) /
              2.0 *
              math.cos(angle - math.pi / 2.0 - degToRad(2.0)),
      knobDiameter1 / 2.0 +
          (knobDiameter1 - 15.0) /
              2.0 *
              math.sin(angle - math.pi / 2.0 - degToRad(2.0)),
    );
    final Offset x3 = Offset(
      knobDiameter1 / 2.0 +
          (knobDiameter1 - 60.0) / 2.0 * math.cos(angle - math.pi / 2.0),
      knobDiameter1 / 2.0 +
          (knobDiameter1 - 60.0) / 2.0 * math.sin(angle - math.pi / 2.0),
    );
    final Offset x4 = Offset(
      knobDiameter1 / 2.0 +
          (knobDiameter1 - 15.0) /
              2.0 *
              math.cos(angle - math.pi / 2.0 + degToRad(2.0)),
      knobDiameter1 / 2.0 +
          (knobDiameter1 - 15.0) /
              2.0 *
              math.sin(angle - math.pi / 2.0 + degToRad(2.0)),
    );
    final Offset x5 = Offset(
      knobDiameter1 / 2.0 +
          knobDiameter1 / 2.0 * math.cos(angle - math.pi / 2.0 + degToRad(4.0)),
      knobDiameter1 / 2.0 +
          knobDiameter1 / 2.0 * math.sin(angle - math.pi / 2.0 + degToRad(4.0)),
    );
    path.moveTo(x1.dx, x1.dy);
    path.lineTo(x2.dx, x2.dy);
    path.quadraticBezierTo(x3.dx, x3.dy, x4.dx, x4.dy);
    path.lineTo(x5.dx, x5.dy);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
