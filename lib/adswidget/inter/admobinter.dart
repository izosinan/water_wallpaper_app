import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:water_wallpaper/main.dart';

class AdmobInter {
  bool isAdLoaded = false;
  late InterstitialAd interstitialAd;
  loadAdmobInter() {
    InterstitialAd.load(
      adUnitId: adTest ? "ca-app-pub-3940256099942544/1033173712" : "ca-app-pub-9662343390040160/8718593387",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;

          isAdLoaded = true;

          interstitialAd.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            ad.dispose();

            isAdLoaded = false;
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();

            isAdLoaded = false;
          });
        },
        onAdFailedToLoad: ((error) {
          interstitialAd.dispose();
        }),
      ),
    );
  }

  showAdmobInter() {
    if (isAdLoaded) {
      interstitialAd.show();
    }
  }
}
