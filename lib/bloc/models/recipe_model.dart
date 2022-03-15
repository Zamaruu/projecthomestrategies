import 'dart:convert';
import 'dart:typed_data';

import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';

class RecipeModel {
  String? id;
  int? householdId;
  int? creatorId;
  String? name;
  String? desctiption;
  String? displayImage;
  int? cookingTime;
  bool? makePublic;
  DateTime? createdAt;
  List<CookingStepModel>? cookingSteps;

  RecipeModel(
      {this.id,
      this.householdId,
      this.creatorId,
      this.name,
      this.desctiption,
      this.displayImage,
      this.cookingTime,
      this.makePublic,
      this.createdAt,
      this.cookingSteps});

  RecipeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    householdId = json['householdId'];
    creatorId = json['creatorId'];
    name = json['name'];
    desctiption = json['desctiption'];
    displayImage = json['displayImage'];
    cookingTime = json['cookingTime'];
    makePublic = json['makePublic'];
    createdAt = DateTime.parse(json['createdAt']).toLocal();
    if (json['cookingSteps'] != null) {
      cookingSteps = <CookingStepModel>[];
      json['cookingSteps'].forEach((v) {
        cookingSteps!.add(CookingStepModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['householdId'] = householdId;
    data['creatorId'] = creatorId;
    data['name'] = name;
    data['desctiption'] = desctiption;
    data['displayImage'] = displayImage;
    data['cookingTime'] = cookingTime;
    data['makePublic'] = makePublic;
    data['createdAt'] = createdAt!.toIso8601String();
    if (cookingSteps != null) {
      data['cookingSteps'] = cookingSteps!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Uint8List? getImageAsBytes() {
    if (displayImage != null) {
      return base64Decode(displayImage!);
    }
    return null;
  }
}
