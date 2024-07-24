import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityInter {
  loadUnityInter() {
    UnityAds.load(
      placementId: 'Interstitial_Android',
      onComplete: (placementId) => print(' $placementId'),
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  showUnityInter() {
    UnityAds.showVideoAd(
      placementId: 'Interstitial_Android',
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) => print('Video Ad $placementId skipped'),
      onComplete: (placementId) => print('Video Ad $placementId complete'),
      onFailed: (placementId, error, message) =>
          print('Video Ad $placementId failed: $error $message'),
    );
  }
}
