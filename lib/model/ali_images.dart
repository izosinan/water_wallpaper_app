class ImageItem {
  final String url;

  ImageItem(this.url);

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(json['url']);
  }
}
