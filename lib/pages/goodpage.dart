import 'package:water_wallpaper/adswidget/native/facenatviead.dart';
import 'package:flutter/material.dart';
import 'package:water_wallpaper/pages/homepage.dart';
import 'package:water_wallpaper/main.dart';

class GoodPage extends StatefulWidget {
  const GoodPage(
      {super.key});

  @override
  State<GoodPage> createState() => _GoodPageState();
}

class _GoodPageState extends State<GoodPage> {
  int adNumber = 1;
  Future<void> _goTo() async {
    await sharedPref!.setInt('adNumber', ++adNumber);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Homepage(
                  )));
    
  }

  @override
  void initState() {
    super.initState();
    adNumber = sharedPref!.getInt('adNumber') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(children: [
          Container(
            height: 20,
          ),
          Image.asset(
            'images/good.png',
            width: 300,
            height: 200,
            fit: BoxFit.cover,
          ),
          const Text(
            'Wallpapers are ready!',
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'You can get started',
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: ElevatedButton(
               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  _goTo();
                },
                child: const Text(
                  'GET STARTED',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
          ),
          const SizedBox(
            height: 40,
          ),
          facebookNativeAd(),
        ]),
      ),
    );
  }
}
