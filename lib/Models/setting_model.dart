class SettingModel {
  int? id;
  String? email;
  String? phone;

  SettingModel({this.id, this.email, this.phone});

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
