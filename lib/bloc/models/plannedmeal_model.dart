import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class PlannendMealModel {
  late int id;
  late DateTime startDay;
  late DateTime endDay;
  late String recipe;
  // late FullRecipeModel recipe;
  late String creator;
  // late UserModel creator;
  late Color color;

  PlannendMealModel(
    this.id,
    this.creator,
    this.startDay,
    this.endDay,
    this.recipe,
    this.color,
  );
}
