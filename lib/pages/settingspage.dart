import 'package:flutter/material.dart';
import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/adswidget/native/facenatviead.dart';
import 'package:water_wallpaper/main.dart';

import 'package:water_wallpaper/pages/usersuggestion.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String url =
      "https://sites.google.com/view/amazing4kwaterwallpaper-privac/";




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white38,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 26,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Stack(
          children: [
            Align(
                // ignore: sort_child_properties_last
                child: showBannerAd(mainAdsName),
                alignment: const AlignmentDirectional(0, 1)),
            ListView(
              children: [
                 ListTile(
                  leading: const Icon(Icons.info, color: Colors.red),
                  title: Text('App Version $appVersion'),
                ),
                const Divider(color: Colors.red),
                ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.red),
                  leading: const Icon(Icons.star_half, color: Colors.red),
                  title: const Text('Rate App'),
                  onTap: () {
                    StoreRedirect.redirect(
                        androidAppId: packageName,
                        iOSAppId: packageName);
                  },
                ),
                const Divider(color: Colors.red),
                ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.red),
                  leading: const Icon(Icons.share, color: Colors.red),
                  title: const Text('Share App'),
                  onTap: () {
                    Share.share(
                        "program '$appName' in its new look, download it on your phone for free! -> https://play.google.com/store/apps/details?id=$packageName");
                  },
                ),
                const Divider(color: Colors.red),
                ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.red),
                  leading: const Icon(Icons.privacy_tip, color: Colors.red),
                  title: const Text('Privacy Policy'),
                  onTap: () async {
                    // ignore: deprecated_member_use
                    if (await canLaunch(url)) {
                      // ignore: deprecated_member_use
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                const Divider(color: Colors.red),
                ListTile(
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.red),
                    leading: const Icon(Icons.send_time_extension_rounded,
                        color: Colors.red),
                    title: const Text('Give us a suggestion'),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return const UserSuggestion();
                      })));
                    }),
                const Divider(color: Colors.red),
                const SizedBox(
                  height: 40,
                ),
                facebookNativeAd(),
              ],
            ),
          ],
        ));
  }
}
