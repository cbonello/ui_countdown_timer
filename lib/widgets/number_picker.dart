import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NumberPicker extends StatefulWidget {
  const NumberPicker({
    Key key,
    @required this.initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.height = kDefaultItemExtent,
    this.width = kDefaultListViewCrossAxisSize,
  })  : assert(minValue != null && minValue >= 0),
        assert(maxValue != null && maxValue >= 0),
        assert(minValue < maxValue),
        assert(
          initialValue != null && minValue <= initialValue && initialValue <= maxValue,
        ),
        assert(onChanged != null),
        super(key: key);

  static const double kDefaultItemExtent = 50.0;
  static const double kDefaultListViewCrossAxisSize = 100.0;

  final int initialValue, minValue, maxValue;
  final double height, width;
  final ValueChanged<int> onChanged;

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  ScrollController scrollController;
  int selectedValue;

  @override
  void initState() {
    scrollController = ScrollController(
      initialScrollOffset: (widget.initialValue - widget.minValue) * widget.height,
    );
    selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int count = widget.maxValue - widget.minValue + 1;

    return NotificationListener<UserScrollNotification>(
      onNotification: (UserScrollNotification notification) {
        if (notification.direction == ScrollDirection.idle) {
          final int index =
              (notification.metrics.pixels / widget.height).round().clamp(0, count - 1);
          animateToIndex(index);
          final int value = widget.minValue + index;
          print('$index - $value');
          if (value != selectedValue) {
            selectedValue = value;
            widget.onChanged(value);
          }
        }
        return true;
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        child: ListView.builder(
          controller: scrollController,
          primary: false,
          itemExtent: widget.height,
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Text(
                (widget.minValue + index).toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 24.0),
              ),
            );
          },
        ),
      ),
    );
  }

  void animateToIndex(int index) {
    // https://github.com/flutter/flutter/issues/14452
    scrollController.animateTo(
      index * widget.height,
      duration: const Duration(seconds: 1),
      curve: const ElasticOutCurve(),
    );
  }
}
