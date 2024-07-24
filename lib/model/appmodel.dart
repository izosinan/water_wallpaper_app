class AppModel {
  final String appName;
  final String appId;
  final String appImage;

  AppModel(
      {required this.appName, required this.appId, required this.appImage});

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      appName: json['app_name'],
      appId: json['app_ID'],
      appImage: json['app_image'],
    );
  }
}
