class UserModel {
  int? role;
  String? userID;
  String? image;
  String? name;
  String? email;
  String? phone;
  String? city;
  int? level;
  int? point;
  bool? isActive;
  String? provider; // Google || Email
  int? watchingVideosAvailableCount;
  int? watchedVideosCount;
  int? lastVideoWatchedTimeStamp;

  UserModel(
      {this.role,
        this.userID,
        this.image,
        this.name,
        this.email,
        this.phone,
        this.city,
        this.level,
        this.point,
        this.provider,
        this.isActive,
        this.watchingVideosAvailableCount,
        this.watchedVideosCount,
        this.lastVideoWatchedTimeStamp});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      role: json['role'] ?? 1,
      userID: json['userID'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      provider: json['provider'] ?? 'Email',
      level: json['level'] ?? 1,
      point: json['point'] ?? 0,
      isActive: json['isActive'] ?? true,
      watchingVideosAvailableCount: json['watchingVideosAvailableCount'] ?? 2,
      watchedVideosCount: json['watchedVideosCount'] ?? 0,
      lastVideoWatchedTimeStamp: json['lastVideoWatchedTimeStamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "role": role,
    "userID": userID,
    "name": name ?? '',
    "image": image ?? '',
    "phone": phone ?? '',
    "city": city ?? '',
    "email": email,
    "provider": provider ?? 'Email',
    "level": level ?? 1,
    "point": point ?? 0,
    "isActive": isActive
  };
}
