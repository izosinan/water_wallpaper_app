import 'package:flutter/material.dart';
import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/main.dart';
import 'package:water_wallpaper/model/appmodel.dart';
import 'package:water_wallpaper/model/appservice.dart';

import 'package:store_redirect/store_redirect.dart';

class Apps extends StatefulWidget {
  const Apps({super.key});

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  final appService = AppService(
      'https://raw.githubusercontent.com/izosinan/jsons/main/water_wallpaer_data.json');
  @override
  void initState() {
    super.initState();
  }


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 238, 25, 132),
          title: const Center(
              child: Text(
            'Apps & Games',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: FutureBuilder<List<AppModel>>(
            future: appService.getApps(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final apps = snapshot.data!;

                return Column(children: [
                  showBannerAd(mainAdsName),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      final String appName = app.appName;
                      final String appId = app.appId;
                      final String appImage = app.appImage;

                      return GestureDetector(
                          onTap: () {
                            StoreRedirect.redirect(
                              androidAppId: appId,
                              iOSAppId: appId,
                            );
                          },
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 4),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Image.network(
                                          appImage,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      appName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              )));
                    },
                  ))
                ]);
              }
            }));
  }
}
