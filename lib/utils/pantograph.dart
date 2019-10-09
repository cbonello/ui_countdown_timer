import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Pantograph extends InheritedWidget {
  const Pantograph({
    Key key,
    @required this.designSize,
    @required this.mediaQueryData,
    this.scaleFonts = true,
    @required Widget child,
  }) : super(key: key, child: child);

  final Size designSize;
  final MediaQueryData mediaQueryData;
  final bool scaleFonts;

  double scaledHeight(double height) =>
      height * mediaQueryData.size.height / designSize.height;

  double ratioHeight(double ratio) {
    assert(ratio > 0 && ratio < 1.0);
    return mediaQueryData.size.height * ratio;
  }

  double scaledWidth(double width) =>
      width * mediaQueryData.size.width / designSize.width;

  double ratioWidth(double ratio) {
    assert(ratio > 0 && ratio < 1.0);
    return mediaQueryData.size.width * ratio;
  }

  T platformValue<T>(T valueAndroid, T valueIOS) {
    return defaultTargetPlatform == TargetPlatform.android
        ? valueAndroid
        : valueIOS;
  }

  static Pantograph of(BuildContext context) {
    final Pantograph p = context.inheritFromWidgetOfExactType(Pantograph);
    assert(p != null);
    return p;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
