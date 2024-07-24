import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:water_wallpaper/main.dart';

bool testMode = adTest;

Widget facebookNativeAd() {
  return NativeAd(
    placementId: testMode
        ? "VID_HD_16_9_15S_APP_INSTALL#$facebookNativeId"
        : facebookNativeId,
    adType: NativeAdType.NATIVE_AD_VERTICAL,
    width: double.infinity,
    height: 300,
    backgroundColor: Colors.blue,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.deepPurple,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    listener: NativeAdListener(
      onError: (code, message) =>
          print('native ad error\ncode: $code\nmessage:$message'),
      onLoaded: () => print('native ad loaded'),
      onMediaDownloaded: () => 'native ad media downloaded',
    ),
    keepExpandedWhileLoading: true,
    expandAnimationDuraion: 1000,
  );
}
