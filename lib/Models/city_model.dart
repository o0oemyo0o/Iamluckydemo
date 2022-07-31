class CityModel {
  String? id;
  String? name;

  CityModel({this.id, this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'],
    );
  }
}
