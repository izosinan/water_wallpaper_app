import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:water_wallpaper/adswidget/banner/show_banner.dart';
import 'package:water_wallpaper/adswidget/inter/show_inter.dart';
import 'package:water_wallpaper/adswidget/native/facenatviead.dart';
import 'package:water_wallpaper/main.dart';

class UserSuggestion extends StatefulWidget {
  const UserSuggestion({super.key});

  @override
  State<UserSuggestion> createState() => _UserSuggestionState();
}

class _UserSuggestionState extends State<UserSuggestion> {

  int adCounter = 0;


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();


 

  @override
  void initState() {
    super.initState();
    loadIntersitial();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String suggestion = _suggestionController.text;

      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // No network connection
        // ignore: avoid_single_cascade_in_expression_statements, use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc:
              'There is no network connection. Please check your internet connection',
          btnCancelOnPress: () {},
          btnCancelText: "Ok",
        )..show();
        return;
      }

      // Save the data to Firebase
      FirebaseFirestore.instance.collection('users_suggestions').add({
        'name': name,
        'suggestion': suggestion,
      }).then((value) async {
        showInterstial(adCounter);
        await Future.delayed(const Duration(milliseconds: 1500));
        loadIntersitial();
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Succes',
          desc: 'Your Suggestion was submited Succesfuly',
          btnOkOnPress: () {},
          btnOkText: "Ok",
        ).show();
      }).catchError((error) {
        // An error occurred while saving the data
        // ignore: avoid_single_cascade_in_expression_statements
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Failed to submit your proposal. Please try again later',
          btnOkOnPress: () {},
          btnOkText: "Ok",
        )..show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Suggestion Page'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16, left: 16, right: 16, top: 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: showBannerAd(mainAdsName),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          label: const Text('Name :'),
                          enabled: true,
                          disabledBorder: OutlineInputBorder(
                              //this changes will active in disable statue
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              )),
                          focusedBorder: OutlineInputBorder(
                            //this changes will active in focus statue
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            //this changes will active in enable statue
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Type Your Name Please';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        maxLines: 3,
                        controller: _suggestionController,
                        decoration: InputDecoration(
                          label: const Text('Suggestion :'),
                          enabled: true,
                          disabledBorder: OutlineInputBorder(
                              //this changes will active in disable statue
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              )),
                          focusedBorder: OutlineInputBorder(
                            //this changes will active in focus statue
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            //this changes will active in enable statue
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Type Your Suggestion Please';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          _submitForm();
                        },
                        child: const Text(
                          'Submit',
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      facebookNativeAd(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
