import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  const Settings({
    @required this.duration,
    @required this.ringtone,
    @required this.volume,
    @required this.vibrate,
  })  : assert(ringtone != null),
        assert(volume >= 0.0 && volume <= 100.0);

  factory Settings.fromDuration(Settings s, int newDuration) {
    return Settings(
      duration: newDuration,
      ringtone: s.ringtone,
      volume: s.volume,
      vibrate: s.vibrate,
    );
  }

  factory Settings.fromRingtone(Settings s, String newRingtone) {
    return Settings(
      duration: s.duration,
      ringtone: newRingtone,
      volume: s.volume,
      vibrate: s.vibrate,
    );
  }

  factory Settings.fromVolume(Settings s, double newVolume) {
    return Settings(
      duration: s.duration,
      ringtone: s.ringtone,
      volume: newVolume,
      vibrate: s.vibrate,
    );
  }

  factory Settings.fromVibrate(Settings s, bool newVibrate) {
    return Settings(
      duration: s.duration,
      ringtone: s.ringtone,
      volume: s.volume,
      vibrate: newVibrate,
    );
  }

  final int duration;
  final String ringtone;
  final double volume;
  final bool vibrate;

  @override
  String toString() =>
      'Settings { duration: $duration, ringtone: "$ringtone", volume: "$volume", vibrate: "$vibrate" }';

  @override
  List<Object> get props => <Object>[ringtone, volume, vibrate];
}
