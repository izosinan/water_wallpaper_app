import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:water_wallpaper/adswidget/banner/testad.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? bannerAd;
  bool _isAdReady = false;
  final AdSize _adSize = AdSize.banner;

  void _createBannerAd() {
    bannerAd = BannerAd(
      size: _adSize,
      adUnitId: HelperAd.bannerAdUnitId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _isAdReady = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        log('ad faild to load : ${error.message}');
      }),
      request: const AdRequest(),
    );
    bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdReady) {
      return Container(
        color: Colors.transparent,
        width: _adSize.width.toDouble(),
        height: _adSize.height.toDouble(),
        child: AdWidget(
          ad: bannerAd!,
        ),
        alignment: Alignment.center,
      );
    }
    return Container();
  }
}
