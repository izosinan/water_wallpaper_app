import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/cpmvideo/videopage.dart';
import 'package:water_wallpaper/main.dart';
import 'package:water_wallpaper/pages/apps.dart';
import 'package:water_wallpaper/pages/loadingpage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String cpaUrl = "";
  String videoUrl = "";
  String imageUrl = "";

  //===============================Initialize json variable===============================================
  Future<void> checkCpmOffer() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/izosinan/jsons/main/cpa.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final cpa = jsonData['url'];
      final video = jsonData['videoUrl'];
      final image = jsonData['imageUrl'];
      setState(() {
        cpaUrl = cpa;
        videoUrl = video;
        imageUrl = image;
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  cpmOffer(url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch the url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }


    void _downloadVideo(webUrl) async {
    String url = webUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

    //============================ firebase Messaging Functions ==============================
  Future<void> setupIntercateMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessageOpenTerminated(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenbackground);
  }

  void _handleMessageOpenTerminated(RemoteMessage message) {
    _handleMessageOpen(message);
  }

  void _handleMessageOpenbackground(message) {
    _handleMessageOpen(message);
  }

  void _handleMessageOpen(RemoteMessage message) {
    if (message.data['page'] == 'apps') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => const Apps())));
    } else if (message.data['page'] == 'ms') {
      Navigator.of(context).pushNamed('ms');
    } else if (message.data['page'] == 'apps') {
      Navigator.of(context).pushNamed('apps');
    } else {
      _downloadVideo(message.data['page']);
    }
  }


  @override
  void initState() {
    super.initState();
    setupIntercateMessage();
    checkCpmOffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: const Color(0xffe26d5c),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             cpaUrl.isNotEmpty 
             ? InkWell(
                  onTap: () {
                    cpmOffer(cpaUrl);
                  },
                  child: imageUrl.isEmpty
                      ? Container(
                        margin: const EdgeInsets.only(top: 1),
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height / 4,
                          child: AutoplayLoopVideo(
                            videoUrl: videoUrl,
                          ),
                        )
                      : Container(
                        margin: const EdgeInsets.only(top:1),
                          width: double.infinity,
                           height: MediaQuery.sizeOf(context).height / 4,
                          child: Image.network(imageUrl,
                              fit: BoxFit.fill),
                        ),
                )
             : mainAdsName == 'admob'
                  ? Container(
                      margin: const EdgeInsets.only(top: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [showBannerAd(mainAdsName)],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 60),
                      child: showBannerAd(mainAdsName)),
              Column(
                children: [
                 const Text(
                    'Now decorate your phone with awesome water wallpaper',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoadingPage(
                                      ))));
                        },
                        child: const Text(
                          'Wallpaper page',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                  if(showApps)
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Apps())));
                        },
                        child: const Text(
                          'More apps',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  )
                ],
              ),
              mainAdsName == 'admob'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [showBannerAd(mainAdsName)],
                    )
                  : showBannerAd(mainAdsName),
            ]),
      ),
    );
  }
}
