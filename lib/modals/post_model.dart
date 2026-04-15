class PostModel {
  final int id;
  final String username;
  final String text;
  final String imageUrl;
  int likes;
  bool isLiked;
  final int noOfComments;
  final String createdAt;

  PostModel({
    required this.id,
    required this.username,
    required this.text,
    required this.imageUrl,
    required this.likes,
    required this.isLiked,
    required this.noOfComments,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["id"],
      username: json["username"],
      text: json["text"],
      imageUrl: json["image_url"],
      likes: json["likes"],
      noOfComments: json["noofcomments"],
      createdAt: json["created_at"],
      isLiked: json["isLiked"],
    );
  }
}
