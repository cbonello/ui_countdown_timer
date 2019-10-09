import 'package:flutter/material.dart';

class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
    this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final Widget label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged?.call(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: label),
            Switch(
              value: value,
              onChanged: (bool newValue) {
                onChanged?.call(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
