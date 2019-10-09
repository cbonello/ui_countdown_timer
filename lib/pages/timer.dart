import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_countdown_timer/bloc/settings/bloc.dart';
import 'package:ui_countdown_timer/bloc/timer/bloc.dart';
import 'package:ui_countdown_timer/utils/pantograph.dart';
import 'package:ui_countdown_timer/widgets/circular_button.dart';
import 'package:ui_countdown_timer/widgets/clock_background.dart';
import 'package:ui_countdown_timer/widgets/clock_face.dart';
import 'package:ui_countdown_timer/widgets/dialog.dart';
import 'package:ui_countdown_timer/widgets/round_button.dart';
import 'package:ui_countdown_timer/widgets/slider.dart';
import 'package:ui_countdown_timer/widgets/switch.dart';
import 'package:vibration/vibration.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Pantograph(
        designSize: const Size(1125.0, 2436.0),
        mediaQueryData: MediaQuery.of(context),
        scaleFonts: true,
        child: BlocProvider<TimerBloc>(
          builder: (_) => TimerBloc(ticker: Ticker()),
          child: TimerWidget(),
        ),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  AnimationController timerAnimCtrl, timerCfgCtlr;
  Animation<double> timerAnim, timerCfgAnim;
  bool canVibrate = false;
  int duration;

  @override
  void initState() {
    timerAnimCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    timerAnim = Tween<double>(begin: 0.0, end: -2 * math.pi)
        .animate(timerAnimCtrl)
          ..addListener(() => setState(() {}));
    timerCfgCtlr = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    timerCfgAnim =
        Tween<double>(begin: 0.0, end: math.pi / 4.0).animate(timerCfgCtlr);
    initVibration().whenComplete(() => setState(() {}));
    duration = 10;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timerCfgCtlr?.dispose();
    timerAnimCtrl?.dispose();
  }

  Future<void> initVibration() async {
    canVibrate = await Vibration.hasVibrator();
  }

  @override
  Widget build(BuildContext context) {
    final double dialDiameter = math.min<double>(
      Pantograph.of(context).scaledHeight(670),
      Pantograph.of(context).scaledWidth(670),
    );

    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color(0xFFFDFEFE),
        ),
        Center(
          child: ClockBackground(
            hOffset: kToolbarHeight +
                Pantograph.of(context).scaledHeight(60) +
                Pantograph.of(context).scaledHeight(160),
            dialDiameter: dialDiameter,
            knobDiameter1: dialDiameter * 1.21,
            knobDiameter2: dialDiameter * 1.42,
          ),
        ),
        Positioned(
          top: kToolbarHeight +
              Pantograph.of(context).scaledHeight(60) +
              Pantograph.of(context).scaledHeight(160) +
              Pantograph.of(context).scaledHeight(25),
          left: MediaQuery.of(context).size.width / 2.0 -
              (dialDiameter * 1.42) / 2.0,
          width: dialDiameter * 1.42,
          height: dialDiameter * 1.42,
          child: AnimatedBuilder(
            animation: timerAnim,
            builder: (BuildContext context, Widget child) {
              return ClockFace(
                angle: timerAnim.value,
                hOffset: kToolbarHeight +
                    Pantograph.of(context).scaledHeight(60) +
                    Pantograph.of(context).scaledHeight(160),
                dialDiameter: dialDiameter,
                knobDiameter1: dialDiameter * 1.21,
                knobDiameter2: dialDiameter * 1.42,
              );
            },
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Timer'),
          ),
          body: Center(
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: Pantograph.of(context).scaledHeight(60.0)),
                  CircularButton(
                    size: Pantograph.of(context).scaledHeight(160.0),
                    animation: timerCfgAnim,
                    onPressed: () {
                      timerCfgAnim.isCompleted
                          ? timerCfgCtlr.reverse()
                          : timerCfgCtlr.forward();
                      OverlayEntry overlayEntry;
                      overlayEntry = OverlayEntry(
                        builder: (_) {
                          return DialogBubble(
                            hOffset: kToolbarHeight +
                                Pantograph.of(context).scaledHeight(60) +
                                Pantograph.of(context).scaledHeight(160) +
                                Pantograph.of(context).scaledHeight(25),
                            duration: duration,
                            onClose: (int seconds) {
                              overlayEntry.remove();
                            },
                          );
                        },
                      );
                      Overlay.of(context).insert(overlayEntry);
                    },
                  ),
                  SizedBox(
                    height: Pantograph.of(context).scaledHeight(25.0) +
                        dialDiameter * 0.15,
                  ),
                  SizedBox(height: dialDiameter),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Icon(Icons.edit, color: Color(0xFF50979D)),
                      Icon(Icons.notifications, color: Color(0xFF50979D)),
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<SettingsBloc, Settings>(
                    builder: (BuildContext context, Settings settings) {
                      return ListTile(
                        title: Text(
                          settings.ringtone,
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () async => await Navigator.pushNamed(
                          context,
                          '/ringtone',
                          arguments: settings.ringtone,
                        ),
                        trailing: const Icon(Icons.navigate_next),
                        contentPadding: const EdgeInsets.all(0.0),
                        leading: Container(
                          padding: EdgeInsets.only(
                            right: Pantograph.of(context).scaledWidth(16.0),
                            top: Pantograph.of(context).scaledHeight(8.0),
                            bottom: Pantograph.of(context).scaledHeight(8.0),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Pantograph.of(context).scaledWidth(4.0),
                              right: Pantograph.of(context).scaledWidth(40.0),
                            ),
                            child: const Text(
                              'Ringtone',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  BlocBuilder<SettingsBloc, Settings>(
                    builder: (BuildContext context, Settings settings) {
                      return LabeledSlider(
                        title: const Text(
                          'Volume',
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                        value: settings.volume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (double newVolume) {
                          BlocProvider.of<SettingsBloc>(context).dispatch(
                            UpdateSettings(
                              Settings.fromVolume(settings, newVolume),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  Theme(
                    data: Theme.of(context).copyWith(
                      toggleableActiveColor: const Color(0xFF50979D),
                    ),
                    child: BlocBuilder<SettingsBloc, Settings>(
                      builder: (BuildContext context, Settings settings) {
                        return LabeledSwitch(
                          label: const Text(
                            'Vibrate when ringing',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          padding: EdgeInsets.only(
                            left: Pantograph.of(context).scaledWidth(3.0),
                          ),
                          value: canVibrate && settings.vibrate,
                          onChanged: canVibrate
                              ? (bool newVibration) {
                                  Vibration.vibrate();
                                  setState(
                                    () {
                                      BlocProvider.of<SettingsBloc>(context)
                                          .dispatch(
                                        UpdateSettings(
                                          Settings.fromVibrate(
                                            settings,
                                            newVibration,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<TimerBloc, TimerState>(
                    condition: (TimerState previousState,
                            TimerState currentState) =>
                        currentState.runtimeType != previousState.runtimeType,
                    builder: (BuildContext context, TimerState state) {
                      return Actions(
                        state: state,
                        animationController: timerAnimCtrl,
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({
    Key key,
    @required this.animationController,
    @required this.state,
  }) : super(key: key);

  final AnimationController animationController;
  final TimerState state;

  @override
  Widget build(BuildContext context) {
    if (state is Ready) {
      return RoundButton(
        label: 'START',
        elevation: Pantograph.of(context).platformValue(1.0, 0.0),
        onPressed: () {
          final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);
          timerBloc.dispatch(Start(duration: 10));
          animationController.duration = Duration(
            seconds: 10,
          );
          animationController.forward();
        },
      );
    }
    if (state is Running) {
      return RoundButton(
        label: 'PAUSE',
        elevation: Pantograph.of(context).platformValue(1.0, 0.0),
        onPressed: () {
          final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);
          timerBloc.dispatch(Pause());
          animationController.stop();
        },
      );
    }
    if (state is Paused) {
      return RoundButton(
        label: 'RESUME',
        elevation: Pantograph.of(context).platformValue(1.0, 0.0),
        onPressed: () {
          final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);
          timerBloc.dispatch(Resume());
          animationController.forward();
        },
      );
    }
    if (state is Finished) {
      return RoundButton(
        label: 'RESET',
        elevation: Pantograph.of(context).platformValue(1.0, 0.0),
        onPressed: () {
          final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);
          timerBloc.dispatch(Reset());
          animationController.reset();
        },
      );
    }
    return Container();
  }
}
