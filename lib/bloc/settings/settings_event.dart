import 'package:equatable/equatable.dart';
import 'package:ui_countdown_timer/bloc/settings/settings_state.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateSettings extends SettingsEvent {
  const UpdateSettings(this.settings) : assert(settings != null);

  final Settings settings;

  @override
  String toString() => 'UpdateSettings { settings: "$settings" }';

  @override
  List<Object> get props => <Object>[settings];
}
