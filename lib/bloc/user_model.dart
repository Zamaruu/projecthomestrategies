import 'package:projecthomestrategies/bloc/household_model.dart';

class UserModel {
  int? userId;
  String? firstname;
  String? surname;
  String? email;
  String? password;
  int? userColor;
  int? type;
  HouseholdModel? household;

  UserModel(
      {this.userId,
      this.firstname,
      this.surname,
      this.email,
      this.password,
      this.userColor,
      this.type,
      this.household});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstname = json['firstname'];
    surname = json['surname'];
    email = json['email'];
    password = json['password'];
    userColor = json['userColor'];
    type = json['type'];
    household = json["household"] != null
        ? HouseholdModel.fromJson(json['household'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['firstname'] = firstname;
    data['surname'] = surname;
    data['email'] = email;
    data['password'] = password;
    data['userColor'] = userColor;
    data['type'] = type;
    data['household'] = household!.toJson();
    return data;
  }
}
