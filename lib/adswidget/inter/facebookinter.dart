import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:water_wallpaper/main.dart';

class FacebookInter {
  bool testMode = adTest;
  bool _isInterstitialAdLoaded = false;
  InterstitialAd? _interstitialAd;

  loadFbInter() {
    final interstitialAd = InterstitialAd(
        testMode ? InterstitialAd.testPlacementId : facebookInterId);
    interstitialAd.listener = InterstitialAdListener(
      onLoaded: () {
        _isInterstitialAdLoaded = true;
        print(
            '=======================interstitial ad loaded=======================');
      },
      onError: (code, message) {
        print(
            '=======================interstitial ad error\ncode = $code\nmessage = $message=======================');
      },
      onDismissed: () {
        // load next ad already
        interstitialAd.destroy();
        _isInterstitialAdLoaded = false;
      },
    );
    interstitialAd.load();
    _interstitialAd = interstitialAd;
  }

  showFbInter() {
    final interstitialAd = _interstitialAd;

    if (interstitialAd != null && _isInterstitialAdLoaded == true) {
      interstitialAd.show();
    } else {
      print(
          "=======================Interstial Ad not yet loaded!=======================");
    }
  }
}

