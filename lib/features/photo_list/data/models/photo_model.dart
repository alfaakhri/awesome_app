class PhotoModel {
  final String id;
  final String photographer;
  final String url;
  final String imageUrl;

  PhotoModel({
    required this.id,
    required this.photographer,
    required this.url,
    required this.imageUrl,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'].toString(),
      photographer: json['photographer'],
      url: json['url'],
      imageUrl: json['src']['medium'],
    );
  }
}
