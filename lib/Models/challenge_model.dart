class ChallengeModel {
  String? id;
  String? image;
  String? title;
  int? points;
  String? description;
  bool? isAdminApproved;
  bool? isUserApproved;
  bool? isActive;

  ChallengeModel({
    this.id,
    this.image,
    this.title,
    this.points,
    this.description,
    this.isAdminApproved,
    this.isUserApproved,
    this.isActive,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      points: json['points'] ?? 0,
      description: json['description'] ?? '',
      isAdminApproved: json['isAdminApproved'] ?? false,
      isUserApproved: json['isUserApproved'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }
}
