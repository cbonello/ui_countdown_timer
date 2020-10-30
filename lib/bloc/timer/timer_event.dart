import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => <Object>[];
}

class Start extends TimerEvent {
  const Start({@required this.duration});

  final int duration;

  @override
  String toString() => 'Start { duration: $duration }';

  @override
  List<Object> get props => <Object>[duration];
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
  const Tick({@required this.duration});

  final int duration;

  @override
  String toString() => 'Tick { duration: $duration }';

  @override
  List<Object> get props => <Object>[duration];
}
