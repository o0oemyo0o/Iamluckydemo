class QuoteModel {
  String? id;
  String? title;
  String? description;
  bool? isActive;

  QuoteModel({
    this.id,
    this.title,
    this.description,
    this.isActive,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
