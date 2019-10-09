import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key key,
    @required this.label,
    this.elevation = 0.0,
    @required this.onPressed,
  }) : super(key: key);

  final String label;
  final double elevation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            elevation: elevation,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'BebasNeue',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
              maxLines: 1,
                  overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
