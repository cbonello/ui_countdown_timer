import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ui_countdown_timer/utils/pantograph.dart';

class ClockBackground extends StatelessWidget {
  const ClockBackground({
    Key key,
    this.hOffset,
    this.dialDiameter,
    this.knobDiameter1,
    this.knobDiameter2,
  }) : super(key: key);

  final double hOffset, dialDiameter, knobDiameter1, knobDiameter2;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double vheight = Pantograph.of(context).scaledHeight(25.0);

    // size.width / 2.0,
    // hOffset + (dialDiameter * 1.42) / 2.0 - kToolbarHeight,

    // return Container(
    //   child: CustomPaint(
    //     child: Container(
    //       height: (288 + 34) * screenSize.height / 475 - kToolbarHeight,
    //     ),
    //     painter: CurvePainter(),
    //   ),
    // );

    return CustomMultiChildLayout(
      children: <Widget>[
        LayoutId(
          id: 'background',
          child: CustomPaint(
            painter: _BackgroundPainter(
              screenSize: screenSize,
              hOffset: hOffset + vheight,
              dialDiameter: dialDiameter,
              knobDiameter1: knobDiameter1,
              knobDiameter2: knobDiameter2,
            ),
            child: Container(),
          ),
        ),
        LayoutId(
          id: 'knob2',
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF50979D),
            ),
          ),
        ),
        LayoutId(
          id: 'knob1',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: const Alignment(0.0, 0.0),
                end: Alignment.bottomRight,
                colors: const <Color>[
                  Color(0xFF50979D),
                  Color(0x40287C84),
                ],
              ),
            ),
          ),
        ),
        LayoutId(
          id: 'main-dial',
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment(0.2, -0.2),
                radius: 0.5,
                colors: <Color>[
                  Color(0xFFDFF8FA),
                  Color(0xFFAAD6D9),
                ],
                stops: <double>[0.4, 1.0],
              ),
            ),
          ),
        ),
      ],
      delegate: _LayoutDelegate(
        context: context,
        screenSize: screenSize,
        hOffset: hOffset + vheight,
        dialDiameter: dialDiameter,
        knobDiameter1: knobDiameter1,
        knobDiameter2: knobDiameter2,
      ),
    );
  }
}

class _LayoutDelegate extends MultiChildLayoutDelegate {
  _LayoutDelegate({
    this.context,
    this.screenSize,
    this.hOffset,
    this.dialDiameter,
    this.knobDiameter1,
    this.knobDiameter2,
  });

  final BuildContext context;
  final Size screenSize;
  final double hOffset, dialDiameter, knobDiameter1, knobDiameter2;

  @override
  void performLayout(Size size) {
    if (hasChild('background')) {
      layoutChild(
        'background',
        BoxConstraints(
            maxWidth: screenSize.width, maxHeight: screenSize.height),
      );
      positionChild('background', const Offset(0.0, 0.0));
    }
    if (hasChild('main-dial')) {
      layoutChild(
        'main-dial',
        BoxConstraints(maxWidth: dialDiameter, maxHeight: dialDiameter),
      );
      positionChild(
        'main-dial',
        Offset(
          screenSize.width / 2.0 - dialDiameter / 2.0,
          hOffset + (knobDiameter2 - dialDiameter) / 2.0,
        ),
      );
    }
    if (hasChild('knob1')) {
      layoutChild(
        'knob1',
        BoxConstraints.tightFor(
          width: knobDiameter1,
          height: knobDiameter1,
        ),
      );
      positionChild(
        'knob1',
        Offset(
          screenSize.width / 2.0 - knobDiameter1 / 2.0,
          hOffset + (knobDiameter1 - dialDiameter) / 2.0,
        ),
      );
    }
    if (hasChild('knob2')) {
      layoutChild(
        'knob2',
        BoxConstraints.tightFor(
          width: knobDiameter2,
          height: knobDiameter2,
        ),
      );
      positionChild(
        'knob2',
        Offset(
          screenSize.width / 2.0 - knobDiameter2 / 2.0,
          hOffset,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(_LayoutDelegate oldDelegate) => false;
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    Listenable repaint,
    this.context,
    this.screenSize,
    this.hOffset,
    this.dialDiameter,
    this.knobDiameter1,
    this.knobDiameter2,
  }) : super(repaint: repaint);

  final BuildContext context;
  final Size screenSize;
  final double hOffset, dialDiameter, knobDiameter1, knobDiameter2;

  num degToRad(num deg) => deg * (math.pi / 180.0);

  List<Offset> intersection(
    double a,
    double b,
    double cx,
    double cy,
    double r,
  ) {
    final List<Offset> result = <Offset>[];
    final double A = 1 + a * a;
    final double B = 2 * (-cx + a * b - a * cy);
    final double C = cx * cx + cy * cy + b * b - 2 * b * cy - r * r;
    final double delta = B * B - 4 * A * C;
    if (delta > 0) {
      double x = (-B - math.sqrt(delta)) / (2 * A);
      double y = a * x + b;
      result.add(Offset(x, y));
      x = (-B + math.sqrt(delta)) / (2 * A);
      y = a * x + b;
      result.add(Offset(x, y));
    } else if (delta == 0) {
      final double x = -B / (2 * A);
      final double y = a * x + b;
      result.add(Offset(x, y));
    }
    return result;
  }

  double curve(double dx, double dy) {
    return 1226.506 - 0.7705557 * dx + 0.005047444 * dx * dx;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centerDial = Offset(
      screenSize.width / 2.0,
      hOffset + knobDiameter2 / 2.0,
    );
    final double line1 = centerDial.dy + (dialDiameter / 2.0) * 0.68;
    final double line2 = centerDial.dy + (dialDiameter / 2.0);

    final List<Offset> r1 = intersection(
      0,
      line1,
      screenSize.width / 2.0,
      hOffset + knobDiameter2 / 2.0,
      knobDiameter2 / 2.0,
    );
    final List<Offset> r2 = intersection(
      0,
      line2,
      screenSize.width / 2.0,
      hOffset + knobDiameter2 / 2.0,
      knobDiameter2 / 2.0,
    );

    final Path path = Path();
    final Paint paint = Paint();

    path.lineTo(0, r1[0].dy);
    path.lineTo(r1[0].dx / 2.0, r1[0].dy);
    path.quadraticBezierTo(
      r1[0].dx,
      r1[0].dy,
      r2[0].dx,
      r2[0].dy,
    );
    path.lineTo(r2[1].dx, r2[1].dy);
    path.quadraticBezierTo(r1[1].dx, r1[1].dy,
        r1[1].dx + (screenSize.width - r1[1].dx) / 2.0, r1[1].dy);
    path.lineTo(size.width, line1);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = const Color(0xFF50979D);
    canvas.drawPath(path, paint);

    // final Paint fillPaintDial = Paint()..style = PaintingStyle.fill;
    // canvas.drawCircle(r1[0], 4.0, fillPaintDial..color = Colors.yellow);
    // canvas.drawCircle(r1[1], 4.0, fillPaintDial..color = Colors.blue);
    // canvas.drawCircle(r2[0], 4.0, fillPaintDial..color = Colors.green);
    // canvas.drawCircle(r2[1], 4.0, fillPaintDial..color = Colors.pink);

    // final Paint fillPaint1 = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.fill;
    // path = Path();
    // path.addArc(
    //   const Rect.fromLTWH(
    //     129.0,
    //     419.0,
    //     167.0 - 129.0,
    //     475.0 - 419.0,
    //   ),
    //   degToRad(90),
    //   degToRad(0),
    // );
    // path.close();
    // canvas.drawPath(path, fillPaint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
