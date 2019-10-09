import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

const Map<String, String> Ringtones = <String, String>{
  'New Nokia 2013': 'audio/alarm_new_nokia_2013.mp3',
  'Loving You': 'audio/alarm_loving_you.mp3',
  'Alarm Clock': 'audio/alarm_clock.mp3',
  'Simple Marimba': 'audio/simple_marimba.mp3',
};

class SettingsBloc extends Bloc<SettingsEvent, Settings> {
  @override
  Settings get initialState => Settings(
        ringtone: Ringtones.keys.elementAt(0),
        volume: 0.5,
        vibrate: true,
      );

  @override
  Stream<Settings> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is UpdateSettings) {
      yield event.settings;
    }
  }
}
