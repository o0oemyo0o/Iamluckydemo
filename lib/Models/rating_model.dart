class RatingModel {
  String? id;
  String? productID;
  String? productName;
  String? userID;
  String? userName;
  String? comment;
  num? rating;
  bool? isVisited;
  bool? isRewardReceived;
  bool? isAdminAccepted;

  RatingModel(
      {this.id,
      this.productID,
      this.productName,
      this.userID,
      this.userName,
      this.comment,
      this.rating,
      this.isVisited,
      this.isRewardReceived,
      this.isAdminAccepted});

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        isVisited: json['isVisited'] ?? false,
        isRewardReceived: json['isRewardReceived'] ?? false,
        isAdminAccepted: json['isAdminAccepted'] ?? false,
        rating: json['rating'] ?? 0,
        productID: json['productID'] ?? '',
        productName: json['productName'] ?? '',
        comment: json['comment'] ?? '',
        userID: json['userID'] ?? '',
        userName: json['userName'] ?? '',
      );
}
