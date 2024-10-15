class GalleryModel {
  final int galleryId;
  final String galleryImage;

  GalleryModel({
    required this.galleryId,
    required this.galleryImage,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      galleryId: json['gallery_id'],
      galleryImage: json['gallery_image'],
    );
  }
}

class GalleryResponse {
  final List<GalleryModel> galleryList;

  GalleryResponse({required this.galleryList});

  factory GalleryResponse.fromJson(Map<String, dynamic> json) {
    var galleryJson = json['data']['gallery'] as List;
    List<GalleryModel> galleryList =
        galleryJson.map((e) => GalleryModel.fromJson(e)).toList();
    return GalleryResponse(galleryList: galleryList);
  }
}
