import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  String? id;
  String? nameAr;
  String? nameEn;
  int? count;
  int? countToReward;
  String? message;
  int? rewardPoints;

  int completedCount;
  int countToEarn;

  TaskModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.count,
    this.countToReward,
    this.message,
    this.rewardPoints,
    this.completedCount = 0,
    this.countToEarn = 0,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      // id: json[''],
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      count: json['count'] ?? 0,
      countToReward: json['countToReward'] ?? 0,
      rewardPoints: json['reward_points'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nameAr': nameAr,
        'nameEn': nameEn,
        'count': count,
        'countToReward': countToReward,
        'reward_points': rewardPoints,
        'message': message,
      };
}
