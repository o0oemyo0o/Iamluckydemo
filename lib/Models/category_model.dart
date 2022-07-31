class CategoryModel {
  String? id;
  String? name;
  String? image;

  CategoryModel({this.id, this.name, this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
      image: json['image'],
    );
  }
}
