import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/adswidget/inter/show_inter.dart';
import 'package:water_wallpaper/main.dart';
import 'package:flutter/material.dart';
import 'package:water_wallpaper/pages/goodpage.dart';
import 'package:water_wallpaper/utils/utils.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage(
      {super.key,});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  double progress = 0.0;
  int adCounter = 0;
  int index = 0;
  List<String> loadingList = [
    "Please wait, we are preparing wallpapers."
        "Please one moment...",
    "Donloading wallpapers...",
    "Almost done...",
    "Loading more and more ...",
    "Initializing wallpapers... Please wait.",
    "Fetching latest updtes... Hold on.",
    "Almost there! Just a few more seconds...",
    "Preparing the ultimate experience for you...",
    "Sit back relax, we're setting things up..."
  ];




  @override
  void initState() {
    super.initState();
    _simulateLoading();
    loadIntersitial();
  }

  void _simulateLoading() async {
    while (progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 120));
      setState(() {
        progress += 0.01;
        index++;
        if (index == 9) {
          index = 0;
        }
      });

      if (progress >= 1.0) {
        showInterstial(adCounter);
        adCounter++;
        await sharedPref!.setInt('adNumber', adCounter);
        await Future.delayed(const Duration(milliseconds: 1500));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const GoodPage(
                  )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.179, -0.289),
            end: Alignment(-1, -0.07),
            colors: <Color>[Color(0x7f252866), Color(0x7f252bc5)],
            stops: <double>[0, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: mainAdsName == 'admob'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [showBannerAd(mainAdsName)],
                    )
                  : showBannerAd(mainAdsName),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loadingList[index],
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 20,
                  margin: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(20),
                    value: progress, // Update progress value
                    valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 33 * fem,
                  height: 20 * fem,
                  child: Text(
                    '${(progress * 100).round()}%',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ],
            ),
            mainAdsName == 'admob'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [showBannerAd(mainAdsName)],
                  )
                : showBannerAd(mainAdsName),
          ],
        ),
      ),
    );
  }
}
