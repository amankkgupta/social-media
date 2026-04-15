class EditPostModel {
  final int id;
  final String text;
  final String imageUrl;

  EditPostModel({
    required this.id,
    required this.text,
    required this.imageUrl,
  });

  factory EditPostModel.fromJson(Map<String, dynamic> json) {
    return EditPostModel(
      id: json["id"],
      text: json["text"] ?? "",
      imageUrl: json["image"] ?? "",
    );
  }
}
