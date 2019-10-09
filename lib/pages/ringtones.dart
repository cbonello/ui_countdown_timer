import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_countdown_timer/bloc/settings/bloc.dart';

class RingtonesPage extends StatefulWidget {
  const RingtonesPage({Key key, @required this.currentRingtone})
      : super(key: key);

  final String currentRingtone;

  @override
  _RingtonesPageState createState() => _RingtonesPageState();
}

class _RingtonesPageState extends State<RingtonesPage> {
  String currentRingtone;
  AudioCache audioCache;
  AudioPlayer advancedPlayer;

  @override
  void initState() {
    currentRingtone = widget.currentRingtone;
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
    super.initState();
  }

  @override
  void dispose() {
    audioCache.clearCache();
    advancedPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    Future<bool> _onWillPop() async {
      if (currentRingtone == widget.currentRingtone) {
        return true;
      }

      return showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Discard Ringtone?'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Cancel'),
                    textTheme: ButtonTextTheme.primary,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: const Text('Discard'),
                    textTheme: ButtonTextTheme.primary,
                    onPressed: () {
                      advancedPlayer.stop();
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ) ??
          false;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ringtone'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FlatButton(
                child: Text(
                  'SAVE',
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                onPressed: () {
                  advancedPlayer.stop();
                  if (currentRingtone != widget.currentRingtone) {
                    BlocProvider.of<SettingsBloc>(context).dispatch(
                      UpdateSettings(
                        Settings.fromRingtone(
                          settingsBloc.currentState,
                          currentRingtone,
                        ),
                      ),
                    );
                  }
                  Navigator.pop<void>(context);
                },
                padding: const EdgeInsets.symmetric(vertical: 3.0),
              ),
            ),
          ],
        ),
        body: Form(
          onWillPop: _onWillPop,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Scrollbar(
              child: ListView.separated(
                itemCount: Ringtones.keys.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int i) {
                  final String key = Ringtones.keys.elementAt(i);
                  return LabeledRadio<String>(
                    label: key,
                    padding: const EdgeInsets.all(2.0),
                    groupValue: currentRingtone,
                    value: key,
                    onChanged: (String newRingtone) {
                      audioCache.play(
                        Ringtones[newRingtone],
                        volume: settingsBloc.currentState.volume,
                      );
                      setState(() {
                        if (newRingtone != currentRingtone) {
                          currentRingtone = newRingtone;
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    @required this.label,
    @required this.padding,
    @required this.groupValue,
    @required this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final T groupValue;
  final T value;
  final Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<T>(
              groupValue: groupValue,
              value: value,
              onChanged: (T newValue) => onChanged(newValue),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
