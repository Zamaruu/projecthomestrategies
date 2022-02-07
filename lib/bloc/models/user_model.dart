import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';

class UserModel {
  int? userId;
  String? firstname;
  String? surname;
  String? email;
  String? password;
  String? fcmToken;
  String? imageAsBase64;
  Image? image;
  DateTime? createdAt;
  int? userColor;
  Color? color;
  int? type;
  HouseholdModel? household;

  UserModel({
    this.userId,
    this.firstname,
    this.surname,
    this.email,
    this.password,
    this.fcmToken,
    this.userColor,
    this.type,
    this.household,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstname = json['firstname'];
    surname = json['surname'];
    email = json['email'];
    password = json['password'];
    fcmToken = json['fcmToken'];
    imageAsBase64 = json['image'];
    image = _imageFromBase64String(imageAsBase64);
    createdAt = DateTime.parse(json['createdAt']);
    userColor = json['userColor'];
    color = Color(userColor!);
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
    data['image'] = imageAsBase64;
    data['createdAt'] = createdAt.toString();
    data['fcmToken'] = fcmToken;
    data['userColor'] = userColor;
    data['type'] = type;
    if (household != null) {
      data['household'] = household!.toJson();
    }
    return data;
  }

  Image? _imageFromBase64String(String? base64String) {
    if (base64String != null) {
      if (base64String.isNotEmpty) {
        return Image.memory(base64Decode(base64String));
      }
    }
  }
}
