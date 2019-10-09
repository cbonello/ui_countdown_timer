import 'package:flutter/material.dart';
import 'package:ui_countdown_timer/utils/pantograph.dart';

class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    Key key,
    @required this.title,
    @required this.value,
    @required this.min,
    @required this.max,
    this.onChangeStart,
    @required this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  final Widget title;
  final double value, min, max;
  final ValueChanged<double> onChangeStart, onChanged, onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: Pantograph.of(context).scaledWidth(4.0),
            bottom: Pantograph.of(context).scaledHeight(8.0),
          ),
          child: title,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF50979D),
                inactiveTrackColor: Colors.grey[350],
                trackHeight: 3.0,
                thumbColor: const Color(0xFF50979D),
                thumbShape: _RetroSliderThumbShape(
                  // TODO(cbonello): check on small screen.
                  enabledThumbRadius: Pantograph.of(context).scaledHeight(40.0),
                ),
                // overlayRadius must be less than or equal to enabledThumbRadius
                // so that the track entirely fills the available space.
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: Pantograph.of(context).scaledHeight(2.0),
                ),
              ),
              child: Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChangeStart: onChangeStart,
                  onChanged: onChanged,
                  onChangeEnd: onChangeEnd,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// See https://morioh.com/p/1877201bb51d
class _RetroSliderThumbShape extends SliderComponentShape {
  const _RetroSliderThumbShape({
    @required this.enabledThumbRadius,
  });

  final double enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint1 = Paint()
      ..color = sliderTheme.activeTrackColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, enabledThumbRadius, fillPaint1);

    if (enabledThumbRadius >= 8) {
      final Paint fillPaint2 = Paint()
        ..color = const Color(0xFFFDFEFE)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, enabledThumbRadius / 3.5, fillPaint2);
    }
  }
}
