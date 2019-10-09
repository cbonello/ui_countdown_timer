import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class Start extends TimerEvent {
  Start({@required this.duration}) : super(<dynamic>[duration]);

  final int duration;

  @override
  String toString() => 'Start { duration: $duration }';
}

class Pause extends TimerEvent {
  @override
  String toString() => 'Pause';
}

class Resume extends TimerEvent {
  @override
  String toString() => 'Resume';
}

class Reset extends TimerEvent {
  @override
  String toString() => 'Reset';
}

class Tick extends TimerEvent {
  Tick({@required this.duration}) : super(<dynamic>[duration]);

  final int duration;

  @override
  String toString() => 'Tick { duration: $duration }';
}
