import 'package:projecthomestrategies/bloc/user_model.dart';

enum NotificationType { created, edited, deleted, info }

class NotificationModel {
  int? notificationId;
  String? title;
  String? content;
  bool? seen;
  String? creatorName;
  DateTime? created;
  NotificationType? type;
  UserModel? user;

  NotificationModel(
      {this.notificationId,
      this.content,
      this.seen,
      this.creatorName,
      this.created,
      this.type,
      this.user});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    title = json['title'];
    content = json['content'];
    seen = json['seen'];
    creatorName = json['creatorName'];
    created = DateTime.parse(json['created']).toLocal();
    type = NotificationType.values[json['type']];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['title'] = title;
    data['content'] = content;
    data['seen'] = seen;
    data['creatorName'] = creatorName;
    data['created'] = created;
    data['type'] = type!.index;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
