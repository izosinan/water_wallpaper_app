import 'package:easy_audience_network/ad/banner_ad.dart';
import 'package:water_wallpaper/main.dart';

class FbBanner {
  double fbheigh = BannerSize.STANDARD.height.toDouble();
  bool testMode = adTest;

  facebanner() {
    return BannerAd(
      placementId: testMode
          ? "IMG_16_9_APP_INSTALL#$facebookBannerId"
          : facebookBannerId,
      bannerSize: BannerSize.STANDARD,
      listener: BannerAdListener(
        onError: (code, message) => print('error'),
        onLoaded: () => print('loaded'),
        onClicked: () => print('clicked'),
        onLoggingImpression: () => print('logging impression'),
      ),
    );
  }
}
