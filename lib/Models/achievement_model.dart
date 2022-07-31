class AchievementModel {
  String? id;
  String? downloadUrl;
  String? uploadedBy;
  String? description;

  AchievementModel(
      {this.id, this.downloadUrl, this.description, this.uploadedBy});

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      downloadUrl: json['downloadUrl'],
      uploadedBy: json['uploaded_by'],
      description: json['description'],
    );
  }
}
