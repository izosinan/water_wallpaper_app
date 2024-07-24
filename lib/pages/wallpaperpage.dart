import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/adswidget/inter/show_inter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:water_wallpaper/main.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;
import 'package:wallpaper/wallpaper.dart';

class WallpaperPage extends StatefulWidget {
  final String wallpaperImage;
  const WallpaperPage({super.key, required this.wallpaperImage});

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  bool _isDisable = true;
  late Stream<String> progressString;
  late String res;
  bool downloading = false;
  late String _savedDir;
  late String _fileName;
  bool _downloadComplete = false;
  int adCounter = 0;


  @override
  void initState() {
    super.initState();
    _initializeDownload();
    loadIntersitial();
  }

  Future<void> _initializeDownload() async {
    _savedDir = await _getDownloadPath();
    _fileName = await _getFileName();
  }

  Future<String> _getDownloadPath() async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  Future<String> _getFileName() async {
    final uri = Uri.parse(widget.wallpaperImage);
    return uri.pathSegments.last;
  }

  Future<void> dowloadImage(BuildContext context) async {
    progressString = Wallpaper.imageDownloadProgress(widget.wallpaperImage);
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
    }, onDone: () async {
      setState(() {
        downloading = false;

        _isDisable = false;
      });
    }, onError: (error) {
      setState(() {
        downloading = false;
        _isDisable = true;
      });
    });
  }

  Future<void> _setWallpaper() async {
    await dowloadImage(context);
    var actionSheet =
        CupertinoActionSheet(title: const Text('Set as'), actions: [
      CupertinoActionSheetAction(
          onPressed: () async {
            if (_isDisable) {
              return null;
            } else {
              showInterstial(adCounter);              await Future.delayed(const Duration(milliseconds: 2500));
              loadIntersitial();

              var width = MediaQuery.of(context).size.width;
              var height = MediaQuery.of(context).size.height;
              home = await Wallpaper.homeScreen(
                  options: RequestSizeOptions.resizeFit,
                  width: width,
                  height: height);
              setState(() {
                home = home;
              });

              // ignore: use_build_context_synchronously
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                title: 'Done',
                desc: 'Image set Successfuly',
                btnOkOnPress: () {},
                btnOkText: "Ok",
              ).show();
            }
          },
          child: Text(home)),
      CupertinoActionSheetAction(
          onPressed: () async {
            if (_isDisable) {
              return null;
            } else {
              showInterstial(adCounter);
              await Future.delayed(const Duration(milliseconds: 2500));
              loadIntersitial();
              lock = await Wallpaper.lockScreen();
              setState(() {
                lock = lock;
              });

              // ignore: use_build_context_synchronously
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                title: 'Done',
                desc: 'Image set Successfuly',
                btnOkOnPress: () {},
                btnOkText: "Ok",
              ).show();
            }
          },
          child: Text(lock)),
      CupertinoActionSheetAction(
          onPressed: () async {
            if (_isDisable) {
              return null;
            } else {
              showInterstial(adCounter);
              await Future.delayed(const Duration(milliseconds: 2500));
              loadIntersitial();
              both = await Wallpaper.bothScreen();
              setState(() {
                both = both;
              });

              // ignore: use_build_context_synchronously
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                title: 'Done',
                desc: 'Image set Successfuly',
                btnOkOnPress: () {},
                btnOkText: "Ok",
              ).show();
            }
          },
          child: Text(both)),
    ]);
    await showCupertinoModalPopup(
        context: context, builder: (context) => actionSheet);
  }

  // ignore: unused_element
  void _startDownload(BuildContext context) async {
    final savedDir = '$_savedDir/$_fileName';

    final dio = Dio();
    try {
      await dio.download(widget.wallpaperImage, savedDir);
      setState(() {
        _downloadComplete = true;
      });
      _openDownloadedFile();
    } catch (e) {
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Download failed',
        btnCancelOnPress: () {},
        btnCancelText: "Ok",
      ).show();
    }
  }

  void _openDownloadedFile() async {
    if (_downloadComplete) {
      final file = File('$_savedDir/$_fileName');
      final exists = await file.exists();
      if (exists) {
        final galleryResult = await ImageGallerySaver.saveFile(file.path);
        if (galleryResult['isSuccess']) {
          final album = await _getCameraRollAlbum();
          if (album != null) {
            final asset = await _saveImageToAlbum(album, file.path);
            if (asset != null) {
              loadIntersitial();
              // ignore: use_build_context_synchronously
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                title: 'Done',
                desc: 'Image downloaded Successfuly',
                btnOkOnPress: () {},
                btnOkText: "Ok",
              ).show();
            }
          }
        } else {
          // ignore: use_build_context_synchronously
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Failed to save image to gallery',
            btnCancelOnPress: () {},
            btnCancelText: "Ok",
          ).show();
        }
      }
    }
  }

  Future<AssetPathEntity?> _getCameraRollAlbum() async {
    final albums = await PhotoManager.getAssetPathList();
    for (final album in albums) {
      if (album.isAll || album.name == 'Camera Roll') {
        return album;
      }
    }
    return null;
  }

  Future<AssetEntity?> _saveImageToAlbum(
      AssetPathEntity album, String imagePath) async {
    final fileName = path.basename(imagePath);
    final galleryDir = await path_provider.getApplicationDocumentsDirectory();
    final galleryPath = path.join(galleryDir.path, fileName);

    final file = File(imagePath);
    final galleryFile = await file.copy(galleryPath);

    final asset = await PhotoManager.editor
        .saveImageWithPath(galleryFile.path, title: '');
    return asset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              imageUrl: widget.wallpaperImage,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    _setWallpaper();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff1C1B1B).withOpacity((0.8)),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Set Wallpaper",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    showInterstial(adCounter);
                    _startDownload(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff1C1B1B).withOpacity((0.8)),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Download",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                showBannerAd(mainAdsName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
