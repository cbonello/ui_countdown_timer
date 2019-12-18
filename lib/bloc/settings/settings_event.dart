import 'package:equatable/equatable.dart';
import 'package:ui_countdown_timer/bloc/settings/settings_state.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class UpdateSettings extends SettingsEvent {
  UpdateSettings(this.settings)
      : assert(settings != null),
        super(<dynamic>[settings]);

  final Settings settings;

  @override
  String toString() => 'UpdateSettings { settings: "$settings" }';
}
