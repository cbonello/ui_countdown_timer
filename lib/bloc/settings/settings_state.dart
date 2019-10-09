import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  Settings({
    @required this.ringtone,
    @required this.volume,
    @required this.vibrate,
  })  : assert(ringtone != null),
        assert(volume >= 0.0 && volume <= 100.0),
        super(<dynamic>[ringtone, volume, vibrate]);

  factory Settings.fromRingtone(Settings s, String newRingtone) {
    return Settings(
      ringtone: newRingtone,
      volume: s.volume,
      vibrate: s.vibrate,
    );
  }

  factory Settings.fromVolume(Settings s, double newVolume) {
    return Settings(
      ringtone: s.ringtone,
      volume: newVolume,
      vibrate: s.vibrate,
    );
  }

  factory Settings.fromVibrate(Settings s, bool newVibrate) {
    return Settings(
      ringtone: s.ringtone,
      volume: s.volume,
      vibrate: newVibrate,
    );
  }

  final String ringtone;
  final double volume;
  final bool vibrate;

  @override
  String toString() =>
      'Settings { ringtone: "$ringtone", volume: "$volume", vibrate: "$vibrate" }';
}
