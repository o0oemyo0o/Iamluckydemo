class ProductModel {
  String? id;
  String? catID;
  String? catName;
  String? storeID;
  String? storeName;
  String? name;
  String? message;
  int? points;

  ProductModel(
      {this.id,
      this.catID,
      this.catName,
      this.storeID,
      this.storeName,
      this.points,
      this.message,
      this.name});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      catID: json['cat_id'] ?? '',
      storeID: json['store_id'] ?? '',
      catName: json['cat_name'] ?? '',
      storeName: json['store_name'] ?? '',
      name: json['name'] ?? '',
      message: json['message'] ?? '',
      points: json['points'] ?? 0,
    );
  }
}
