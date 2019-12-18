import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_countdown_timer/utils/pantograph.dart';
import 'package:ui_countdown_timer/widgets/round_button.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Timer Demo'),
      ),
      body: SafeArea(
        child: Pantograph(
          designSize: const Size(1125.0, 2436.0),
          mediaQueryData: MediaQuery.of(context),
          scaleFonts: true,
          child: HomeWidget(),
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Spacer(),
            RoundButton(
              label: 'TIMER',
              elevation: Pantograph.of(context).platformValue(1.0, 0.0),
              onPressed: () async => await Navigator.of(context).pushNamed('/timer'),
            ),
            const Spacer(),
            RoundButton(
              label: 'SOURCE CODE (GITHUB)',
              elevation: Pantograph.of(context).platformValue(1.0, 0.0),
              onPressed: () async => await _launchURL(
                context,
                'https://github.com/cbonello/ui_countdown_timer',
              ),
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot launch URL')),
      );
    }
  }
}
