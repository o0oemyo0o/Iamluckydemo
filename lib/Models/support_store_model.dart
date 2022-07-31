class SupportStoreModel {
  String? id;
  String? storeName;
  String? image;
  String? cityID;
  String? cityName;
  String? catID;
  String? catName;
  String? buying;
  String? discount;
  String? subscription;
  String? ownerName;
  String? phoneNumber;
  String? email;
  String? website;
  String? mapLink;
  String? instagram;
  String? snapchat;
  String? tiktok;
  String? socialMedia;
  bool? isActive;
  String? lat;
  String? lng;
  String? location;

  SupportStoreModel({
    this.id,
    this.storeName,
    this.image,
    this.cityID,
    this.cityName,
    this.catID,
    this.catName,
    this.buying,
    this.discount,
    this.subscription,
    this.ownerName,
    this.phoneNumber,
    this.email,
    this.website,
    this.mapLink,
    this.instagram,
    this.snapchat,
    this.tiktok,
    this.socialMedia,
    this.isActive,
    this.lat,
    this.lng,
    this.location,
  });

  factory SupportStoreModel.fromJson(Map<String, dynamic> json) =>
      SupportStoreModel(
        id: json['id'] ?? '',
        storeName: json['storeName'] ?? '',
        image: json['image'] ?? '',
        cityID: json['cityID'] ?? '',
        cityName: json['cityName'] ?? '',
        catID: json['catID'] ?? '',
        catName: json['catName'] ?? '',
        buying: json['buying'] ?? '',
        discount: json['discount'] ?? '',
        subscription: json['subscription'] ?? '',
        ownerName: json['ownerName'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        email: json['email'] ?? '',
        website: json['website'] ?? '',
        mapLink: json['mapLink'] ?? '',
        instagram: json['instagram'] ?? '',
        snapchat: json['snapchat'] ?? '',
        tiktok: json['tiktok'] ?? '',
        socialMedia: json['socialMedia'] ?? '',
        isActive: json['isActive'] ?? '',
        lat: json['lat'] ?? '',
        lng: json['lng'] ?? '',
        location: json['location'] ?? '',
      );
}
