import 'package:water_wallpaper/adswidget/inter/admobinter.dart';
import 'package:water_wallpaper/adswidget/inter/facebookinter.dart';
import 'package:water_wallpaper/adswidget/inter/startapp.dart';
import 'package:water_wallpaper/adswidget/inter/unityinter.dart';
import 'package:water_wallpaper/main.dart';

final AdmobInter _admobInter = AdmobInter();
  final FacebookInter _fbInter = FacebookInter();
  final UnityInter _unityInter = UnityInter();
  final StartAppAds _startInter = StartAppAds();

  //==============================Load Inter ================================
  Future<void> loadIntersitial() async {
    if (mainAdsName == 'admob') {
      _admobInter.loadAdmobInter();
    } else if (mainAdsName == 'facebook') {
      if (adNameShow == 'facebook') {
        _fbInter.loadFbInter();
      } else {
        _startInter.loadInterstitialAd3();
      }
    } else if (mainAdsName == 'startApp') {
      _startInter.loadInterstitialAd3();
    } else if (mainAdsName == 'unity') {
      _unityInter.loadUnityInter();
    } else if (mainAdsName == 'adfb') {
      if (adNameShow == 'admob') {
        _admobInter.loadAdmobInter();
      } else {
        _fbInter.loadFbInter();
      }
    } else if (mainAdsName == 'unityfb') {
      if (adNameShow == 'facebook') {
        _fbInter.loadFbInter();
      } else {
        _unityInter.loadUnityInter();
      }
    }
  }

  //==========================Show Inter===============================================
  void showInterstial(int count) async {
    if (mainAdsName == 'admob') {
      if (count % 3 == 0) {
        _admobInter.showAdmobInter();
        loadIntersitial();
      }
    } else if (mainAdsName == 'facebook') {
      if (count % 3 == 0) {
          _fbInter.showFbInter();
          loadIntersitial();
      
      }
    } else if (mainAdsName == 'unityfb') {
      if (count % 3 == 0) {
        if (adNameShow == 'facebook') {
          _fbInter.showFbInter();
         adNameShow = 'unity';

          loadIntersitial();
        } else {
          _unityInter.showUnityInter();
          adNameShow = 'facebook';

          loadIntersitial();
        }
      }
    } else if (mainAdsName == 'adfb') {
      if (count % 3 == 0) {
        if (adNameShow == 'admob') {
          _admobInter.showAdmobInter();
          adNameShow = 'facebook';

          loadIntersitial();
        } else {
          _fbInter.showFbInter();
           adNameShow = 'admob';

          loadIntersitial();
        }
      }
    } else if (mainAdsName == 'startApp') {
      if (count % 3 == 0) {
        _startInter.showInter();

        loadIntersitial();
      }
    } else if (mainAdsName == 'unity') {
      if (count % 3 == 0) {
        _unityInter.showUnityInter();

        loadIntersitial();
      }
    }
  }
