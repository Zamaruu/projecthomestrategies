import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class PlannedMealModel {
  int? plannedMealId;
  DateTime? startDay;
  DateTime? endDay;
  int? color;
  String? basicRecipeName;
  FullRecipeModel? recipe;
  UserModel? creator;
  HouseholdModel? household;

  PlannedMealModel({
    this.plannedMealId,
    this.startDay,
    this.endDay,
    this.color,
    this.basicRecipeName,
    this.recipe,
    this.creator,
    this.household,
  });

  PlannedMealModel.fromJson(Map<String, dynamic> json) {
    plannedMealId = json['plannedMealId'];
    startDay = DateTime.parse(json['startDay']).toLocal();
    endDay = DateTime.parse(json['endDay']);
    color = json['color'];
    basicRecipeName = json['basicRecipeName'];
    recipe = json['recipe'] != null
        ? FullRecipeModel.fromJson(json['recipe'])
        : null;
    creator =
        json['creator'] != null ? UserModel.fromJson(json['creator']) : null;
    household = json['household'] != null
        ? HouseholdModel.fromJson(json['household'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plannedMealId'] = plannedMealId;
    data['startDay'] = startDay.toString();
    data['endDay'] = endDay.toString();
    data['color'] = color;
    data['basicRecipeName'] = basicRecipeName;
    if (recipe != null) {
      data['recipe'] = recipe!.toJson();
    }
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    if (household != null) {
      data['household'] = household!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plannedMealId'] = plannedMealId;
    data['startDay'] = startDay.toString();
    data['endDay'] = endDay.toString();
    data['color'] = color;
    data['basicRecipeName'] = basicRecipeName;
    if (recipe != null) {
      data['recipeId'] = recipe!.recipe!.id!;
    }
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    if (household != null) {
      data['household'] = household!.toJson();
    }
    return data;
  }
}
