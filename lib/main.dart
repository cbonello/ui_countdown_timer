import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_countdown_timer/bloc/settings/bloc.dart';
import 'package:ui_countdown_timer/pages/home.dart';
import 'package:ui_countdown_timer/pages/ringtones.dart';
import 'package:ui_countdown_timer/pages/timer.dart';

class _BlocDelegate extends BlocDelegate {
  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  // Design only works in portrait mode.
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((_) {
    BlocSupervisor.delegate = _BlocDelegate();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      builder: (_) => SettingsBloc(),
      child: MaterialApp(
        title: 'Countdown Timer',
        theme: ThemeData(
          colorScheme: ColorScheme(
            primary: const Color(0xFF50979D),
            primaryVariant: const Color(0xFF287C84),
            secondary: Colors.pink,
            secondaryVariant: Colors.red,
            surface: const Color(0xFFFEFEFE),
            background: const Color(0xFFFEFEFE),
            error: const Color(0xFF343535),
            onPrimary: const Color(0xFFFEFEFE),
            onSecondary: const Color(0xFF343535),
            onSurface: const Color(0xFF343535),
            onBackground: const Color(0xFF343535),
            onError: const Color(0xFFFEFEFE),
            brightness: Brightness.light,
          ),
          fontFamily: 'BebasNeue',
          appBarTheme: const AppBarTheme(color: Color(0xFF50979D)),
          buttonTheme: ButtonThemeData(
            buttonColor: const Color(0xFF50979D),
          ),
          toggleableActiveColor: const Color(0xFF50979D),
        ),
        // darkTheme: ThemeData(
        // TODO(cbonello): Test dark theme.
        //   colorScheme: ColorScheme(
        //     primary: const Color(0xFF50979D),
        //     primaryVariant: const Color(0xFF287C84),
        //     secondary: Colors.pink,
        //     secondaryVariant: Colors.red,
        //     surface: const Color(0xFFFEFEFE),
        //     background: const Color(0xFFFEFEFE),
        //     error: const Color(0xFF343535),
        //     onPrimary: const Color(0xFFFEFEFE),
        //     onSecondary: const Color(0xFF343535),
        //     onSurface: const Color(0xFF343535),
        //     onBackground: const Color(0xFF343535),
        //     onError: const Color(0xFFFEFEFE),
        //     brightness: Brightness.light,
        //   ),
        //   fontFamily: 'BebasNeue',
        //   appBarTheme: const AppBarTheme(color: Color(0xFF50979D)),
        //   buttonTheme: ButtonThemeData(
        //     buttonColor: const Color(0xFF50979D),
        //   ),
        //   toggleableActiveColor: const Color(0xFF50979D),
        // ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return _cupertinoRoute(
                const HomePage(
                  title: 'Countdown Timer Demo',
                ),
                settings,
              );
            case '/timer':
              return _cupertinoRoute(
                TimerPage(),
                settings,
              );
            case '/ringtone':
              return _cupertinoRoute(
                RingtonesPage(currentRingtone: settings.arguments),
                settings,
              );
            default:
              return null;
          }
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  CupertinoPageRoute<void> _cupertinoRoute(
    Widget builder,
    RouteSettings settings,
  ) {
    return CupertinoPageRoute<void>(
      builder: (BuildContext context) => builder,
      settings: settings,
    );
  }
}
