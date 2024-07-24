//========================Show BannerAd =====================================
import 'package:flutter/material.dart';
import 'package:water_wallpaper/adswidget/banner/adbanner.dart';
import 'package:water_wallpaper/adswidget/banner/facebookbanner.dart';

Widget showBannerAd(adsName) {
    switch (adsName) {
      case 'admob':
        return const AdBanner();
      case 'facebook':
        return FbBanner().facebanner();
      case 'adfb':
        return const AdBanner();
      case 'startApp':
        return FbBanner().facebanner();
      case 'unity':
        return FbBanner().facebanner();
      case 'unityfb':
        return FbBanner().facebanner();
      default:
        return Container();
    }
  }