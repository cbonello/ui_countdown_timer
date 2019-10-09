import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_countdown_timer/widgets/number_picker.dart';
import 'package:ui_countdown_timer/widgets/round_button.dart';

class DialogBubble extends StatefulWidget {
  const DialogBubble({
    Key key,
    @required this.hOffset,
    @required this.duration,
    this.onClose,
  }) : super(key: key);

  final double hOffset;
  final int duration;
  final Function(int) onClose;

  @override
  State<StatefulWidget> createState() => DialogBubbleState();
}

class DialogBubbleState extends State<DialogBubble>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimIn;
  Animation<double> scaleAnimIn;
  final double nipHeight = 15.0;
  int hours, minutes, seconds;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    opacityAnimIn = Tween<double>(begin: 0.0, end: 0.4).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    scaleAnimIn =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() => setState(() {}));
    controller.forward();

    hours = (widget.duration / 3600).truncate();
    minutes = ((widget.duration - hours * 3600) / 60).truncate();
    seconds = (widget.duration - hours * 3600 - minutes * 60).truncate();
    print('HMS: $hours, $minutes, $seconds');
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double rotatedNipHalfHeight = getNipHeight(nipHeight) / 2;
    final double offset = nipHeight / 2 + rotatedNipHalfHeight;
    final Offset nipOffset = Offset(0.0, -offset + rotatedNipHalfHeight);

    return SafeArea(
      child: Material(
        color: Colors.black.withOpacity(opacityAnimIn.value),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: ScaleTransition(
            scale: scaleAnimIn,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 50.0,
                    top: widget.hOffset,
                    right: 50.0,
                  ),
                  child: Container(
                    height: 500.0,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFEFEFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: <Widget>[
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const <Widget>[
                                Text('Hours', textAlign: TextAlign.end),
                                Text('Minutes'),
                                Text('Seconds', textAlign: TextAlign.start),
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                NumberPicker(
                                  initialValue: hours,
                                  minValue: 0,
                                  maxValue: 23,
                                  width: 75.0,
                                  onChanged: (int value) {
                                    setState(() => hours = value);
                                  },
                                ),
                                const Spacer(),
                                const Text('|'),
                                const Spacer(),
                                NumberPicker(
                                  initialValue: minutes,
                                  minValue: 0,
                                  maxValue: 59,
                                  width: 75.0,
                                  onChanged: (int value) {
                                    setState(() => minutes = value);
                                  },
                                ),
                                const Spacer(),
                                const Text('|'),
                                const Spacer(),
                                NumberPicker(
                                  initialValue: seconds,
                                  minValue: 0,
                                  maxValue: 59,
                                  width: 75.0,
                                  onChanged: (int value) {
                                    setState(() => seconds = value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          RoundButton(
                            label: 'SAVE',
                            onPressed: () => widget.onClose(
                              hours * 3600 + minutes * 60 + seconds,
                            ),
                          ),
                          const SizedBox(height: 50.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: widget.hOffset),
                  child: nip(nipOffset),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nip(Offset nipOffset) {
    return Transform.translate(
      offset: nipOffset,
      child: RotationTransition(
        turns: const AlwaysStoppedAnimation<double>(45.0 / 360.0),
        child: Material(
          borderRadius: const BorderRadius.all(
            Radius.circular(1.5),
          ),
          color: const Color(0xFFFEFEFE),
          child: Container(
            height: nipHeight,
            width: nipHeight,
          ),
        ),
      ),
    );
  }

  double getNipHeight(double nipHeight) =>
      math.sqrt(2 * math.pow(nipHeight, 2));
}
