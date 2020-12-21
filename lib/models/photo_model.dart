// =====================================
// This is the model class Gallery
// =====================================

class PhotoModel {
  PhotoModel({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  // =============================================================
  // Converting the Json into a custom Dart object
  // Reference: https://www.youtube.com/watch?v=Fo04xk9gIFo
  // =============================================================
  PhotoModel.fromJson(Map<String, dynamic> json) {
    albumId = json["albumId"];
    id = json["id"];
    title = json["title"];
    url = json["url"];
    thumbnailUrl = json["thumbnailUrl"];
  }

//  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
//        albumId: json["albumId"],
//        id: json["id"],
//        title: json["title"],
//        url: json["url"],
//        thumbnailUrl: json["thumbnailUrl"],
//  );
}


