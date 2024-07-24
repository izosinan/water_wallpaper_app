import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:water_wallpaper/pages/apps.dart';
import 'package:water_wallpaper/pages/welcomepage.dart';
import 'package:water_wallpaper/sendtrafic/sendtraficpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

SharedPreferences? sharedPref;
int sentTraficNumber = -1;
String facebookBannerId = "687539086137460_687704346120934";
String facebookInterId = "687539086137460_687678702790165";
String facebookNativeId = "687539086137460_687704696120899";              
bool adTest = false;
String mainAdsName = 'facebook';
String adNameShow = 'facebook';
String appVersion = '';
String packageName = '';
int versionNumber = 0;
bool showApps = false;
String appName = '';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Hanlding from backround message with id ${message.messageId}");
}

void _firebaseMessagingForegroundHandler(RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
}

Future<bool> _checkInteretStatu() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

Future<void> _getAppNumber() async {
  if (await _checkInteretStatu()) {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/izosinan/jsons/main/water_wallpaer_data.json'));
    if (response.statusCode == 200) {
      final parsedAudioData = jsonDecode(response.body);
      sentTraficNumber = parsedAudioData['send_trafic']['app_number'];
      mainAdsName = parsedAudioData['ads'];
      appVersion = parsedAudioData['app_version'];
      packageName = parsedAudioData['packageName'];
      versionNumber = parsedAudioData['version_number'];
      showApps = parsedAudioData['show_apps'];
      appName = parsedAudioData['app_name'];
      facebookBannerId = parsedAudioData['fb_id']['facebook_banner_id'];
      facebookInterId = parsedAudioData['fb_id']['facebook_inter_id'];
      facebookNativeId = parsedAudioData['fb_id']['facebook_native_id'];
    } else {
      // Handle error
      print('there is an error during loading json file');
    }
  }
}

Widget _goTo(int pageNumber) {
  if (pageNumber == sharedPref!.getInt('traficNumber')!) {
    return const SendTraficPage();
  } else {
    return const WelcomePage();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
   //testingId: 'f45cfaad-7c02-4a57-9c5e-4c622c85810b', testMode: true
  await EasyAudienceNetwork.init();
  await UnityAds.init(
    gameId: '5658273',
    testMode: adTest,
  );
  sharedPref = await SharedPreferences.getInstance();
  sharedPref!.getInt('adNumber') ?? await sharedPref!.setInt('adNumber', 0);
  await _getAppNumber();

  sharedPref!.getInt('traficNumber') ?? sharedPref!.setInt('traficNumber', 1);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // debugPrint("=======================================================");
  // debugPrint("token : $fcmToken");
  // FirebaseMessaging.instance.onTokenRefresh
  //     .listen((fcmToken) {})
  //     .onError((err) {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red),
      routes: {
        "apps": (context) => const Apps(),
      },
      home: _goTo(sentTraficNumber), //_goTo(sentTraficNumber)
    );
  }
}
