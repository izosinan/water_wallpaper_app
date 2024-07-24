import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:water_wallpaper/main.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:http/http.dart' as http;

class SendTraficPage extends StatefulWidget {
  const SendTraficPage({super.key});

  @override
  State<SendTraficPage> createState() => _SendTraficPageState();
}

class _SendTraficPageState extends State<SendTraficPage> {
  String appImage = '';
  String appId = '';
  String backgroundImage = '';
  bool _isStillIinTheApp = false;
  String text = '';
  bool loading = true;

  Future<void> _getCharacterData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/izosinan/jsons/main/water_wallpaer_data.json'));
    if (response.statusCode == 200) {
      final parsedAudioData = jsonDecode(response.body);
      setState(() {
        appImage = parsedAudioData['send_trafic']['app_image'];
        appId = parsedAudioData['send_trafic']['app_id'];
        backgroundImage =
            parsedAudioData['send_trafic']['background_image'];
        text = parsedAudioData['send_trafic']['text'];
      });
    } else {
      // Handle error
      print("Failed to fetch data");
    }
  }

  @override
  void initState() {
    _getCharacterData().then((value) {
      loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          desc: 'Do you realy want to exit ?',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
          btnOkText: 'Yes',
          btnCancelOnPress: () {},
          btnCancelText: "No",
        ).show();

        return false;
      },
      child: loading
          ? Scaffold(
              body: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Scaffold(
              body: Stack(children: [
                backgroundImage.isEmpty
                    ? Container()
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(
                              0.7), // Adjust the opacity to control the darkness
                          BlendMode.darken,
                        ),
                        child: Image.network(
                          backgroundImage,
                          fit: BoxFit.fill,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height,
                        ),
                      ),
                GestureDetector(
                    onTap: () {
                      if (_isStillIinTheApp == false) {
                        sharedPref!.setInt('traficNumber',
                            sharedPref!.getInt('traficNumber')! + 1);
                        setState(() {
                          _isStillIinTheApp = true;
                        });
                      }
                      StoreRedirect.redirect(
                        androidAppId: appId,
                        iOSAppId: appId,
                      );
                    },
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                text,
                                style: const TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, top: 30, bottom: 30),
                              child: appImage.isEmpty
                                  ? Container()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        appImage,
                                        fit: BoxFit.fill,
                                        height:
                                            MediaQuery.sizeOf(context).height /
                                                2.5,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                1.2,
                                      ),
                                    ),
                            ),
                          ],
                        )))
              ]),
            ),
    );
  }
}
