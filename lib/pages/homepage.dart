import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/adswidget/inter/show_inter.dart';
import 'package:water_wallpaper/main.dart';
import 'dart:convert';

import 'package:water_wallpaper/model/ali_images.dart';
import 'package:water_wallpaper/pages/settingspage.dart';
import 'package:water_wallpaper/pages/wallpaperpage.dart';
import 'package:store_redirect/store_redirect.dart';

class Homepage extends StatefulWidget {
  const Homepage(
      {super.key,});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<ImageItem> images = [];
  int adNumber = 1;
  String app_version = '1.1.7';


  Future<bool> _checkInteretStatu() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }





  @override
  void initState() {
    super.initState();
    appVersion.isNotEmpty ? app_version = appVersion : app_version = app_version;
    loadIntersitial();
    fetchImages();
    adNumber = sharedPref!.getInt('adNumber') ?? 0;
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/izosinan/jsons/main/water_wallpaers.json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final imageUrls = jsonData["images"] as List<dynamic>;
      setState(() {
        images = imageUrls.map((url) => ImageItem(url)).toList();
      });
    } else {
      // Handle error
      print('Error fetching images: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        iconTheme: const IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        title: RichText(
    text: const TextSpan(
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
      children: <TextSpan>[
        TextSpan(text: 'amazing water', style: TextStyle(color: Colors.black87)),
        TextSpan(text: 'wallpaper', style: TextStyle(color: Colors.redAccent)),
      ],
    ),
  ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
                },
                icon: const Icon(
                  Icons.settings_suggest_outlined,
                  color: Colors.grey,
                  size: 44,
                )),
          )
        ],
      ),
      body: app_version == '1.1.7' && versionNumber != 1
          ? Column(
              children: [
                showBannerAd(mainAdsName),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 6.0,
                        crossAxisSpacing: 6.0,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          
                          onTap: () async {
                            showInterstial(adNumber);
                            adNumber++;
                            sharedPref!.setInt('adNumber', adNumber);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => WallpaperPage(
                                    wallpaperImage: images[index].url))));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: double.infinity,
                              imageUrl: images[index].url,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Align(
                    // ignore: sort_child_properties_last
                    child: showBannerAd(mainAdsName),
                    alignment: const AlignmentDirectional(0, 1)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'Update the application and enjoy with awesome wallpapers for your mobile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            StoreRedirect.redirect(
                                androidAppId:
                                    packageName,
                                iOSAppId:
                                    packageName);
                          },
                          child: const Text('Update'))
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
