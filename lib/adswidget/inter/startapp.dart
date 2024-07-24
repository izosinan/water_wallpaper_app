import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';

class StartAppAds {
  var startAppSdk = StartAppSdk();
  StartAppInterstitialAd? interstitialAd3;

  void loadInterstitialAd3() {
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      interstitialAd3 = interstitialAd;
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  showInter() {
    if (interstitialAd3 != null) {
      interstitialAd3!.show().then((shown) {
        if (shown) {
          interstitialAd3 = null;
        }

        return null;
      }).onError((error, stackTrace) {
        debugPrint("Error showing Interstitial ad: $error");
      });
    }
  }
}
