import 'package:water_wallpaper/main.dart';

class HelperAd {
  static  final bool _testMode = adTest;
  static String get bannerAdUnitId {
    if (_testMode) {
      return "ca-app-pub-3940256099942544/6300978111";
    }
    return "ca-app-pub-9662343390040160/5162491750";
  }
}
