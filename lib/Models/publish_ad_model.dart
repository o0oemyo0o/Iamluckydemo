class PublishAdModel {
  String? id;
  String? storeName;
  String? ownerName;
  String? phoneNumber;
  String? email;
  String? adLink;
  bool? isActive;

  PublishAdModel({
    this.id,
    this.storeName,
    this.ownerName,
    this.phoneNumber,
    this.email,
    this.adLink,
    this.isActive,
  });

  factory PublishAdModel.fromJson(Map<String, dynamic> json) => PublishAdModel(
        id: json['id'] ?? '',
        storeName: json['storeName'] ?? '',
        ownerName: json['ownerName'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        email: json['email'] ?? '',
        adLink: json['adLink'] ?? '',
        isActive: json['isActive'] ?? false,
      );
}
