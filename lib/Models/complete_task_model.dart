import 'dart:convert';

CompleteTaskModel completeTaskModelFromJson(String str) =>
    CompleteTaskModel.fromJson(json.decode(str));

class CompleteTaskModel {
  CompleteTaskModel(
      {this.id,
      this.taskID,
      this.userID,
      this.userName,
      this.completed,
      this.thirdAchieveImage,
      this.secondAchieveImage,
      this.firstAchieveImage,
      this.dateTimeStamp,
      this.feedback,
      this.taskName,
      this.timeFrom,
      this.timeTo,
      this.countToReward = 0,
      this.adminComment,
      this.adminApproved});

  String? id;

  String? taskID;
  String? userID;
  bool? completed;
  num? dateTimeStamp;
  String? feedback;
  String? firstAchieveImage;
  String? secondAchieveImage;
  String? thirdAchieveImage;
  String? taskName;
  String? timeFrom;
  String? timeTo;
  String? userName;

  int? countToReward;
  String? adminComment;
  bool? adminApproved;

  factory CompleteTaskModel.fromJson(Map<String, dynamic> json) {
    return CompleteTaskModel(
      // id: json[''],
      taskID: json['task_id'] ?? '',
      userID: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      completed: json['completed'] ?? false,
      dateTimeStamp: json['dateTime'] ?? 0,
      feedback: json['feedback'] ?? '',
      firstAchieveImage: json['firstAchieveImage'] ?? '',
      secondAchieveImage: json['secondAchieveImage'] ?? '',
      thirdAchieveImage: json['thirdAchieveImage'] ?? '',
      taskName: json['taskName'] ?? '',
      timeFrom: json['timeFrom'] ?? '',
      timeTo: json['timeTo'] ?? '',
      adminComment: json['admin_comment'] ?? '',
      adminApproved: json['admin_approved'] ?? false,
    );
  }
}
