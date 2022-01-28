import 'package:projecthomestrategies/bloc/user_model.dart';

class NotificationModel {
  int? notificationId;
  String? content;
  bool? seen;
  UserModel? user;

  NotificationModel({this.notificationId, this.content, this.seen, this.user});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    content = json['content'];
    seen = json['seen'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['content'] = content;
    data['seen'] = seen;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
