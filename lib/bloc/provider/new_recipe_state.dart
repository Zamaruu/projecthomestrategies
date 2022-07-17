import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';
import 'package:projecthomestrategies/bloc/models/recipe_ingredients_model.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class NewRecipeState with ChangeNotifier {
  late bool _isLoading;
  bool get isLoading => _isLoading;

  late int _householdId;
  int get householdId => _householdId;
  late int _creatorId;
  int get creatorId => _creatorId;
  late TextEditingController _recipeName;
  TextEditingController get recipeName => _recipeName;
  late TextEditingController _description;
  TextEditingController get description => _description;
  late TextEditingController _cookingTimeController;
  TextEditingController get cookingTimeController => _cookingTimeController;
  late Uint8List? _image;
  Uint8List? get image => _image;
  late int _cookingTime;
  int get cookingTime => _cookingTime;
  late bool _makePublic;
  bool get makePublic => _makePublic;
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;
  late List<Ingredients> _ingredients;
  List<Ingredients> get ingredients => _ingredients;
  late List<CookingStepModel> _cookingSteps;
  List<CookingStepModel> get cookingSteps => _cookingSteps;

  NewRecipeState() {
    _isLoading = false;

    _householdId = 0;
    _creatorId = 0;
    _recipeName = TextEditingController(text: "");
    _description = TextEditingController(text: "");
    _cookingTimeController = TextEditingController(text: "");
    _image = null;
    _cookingTime = 0;
    _makePublic = false;
    _createdAt = DateTime.now().toLocal();
    _cookingSteps = <CookingStepModel>[];
    _ingredients = <Ingredients>[];
  }

  void setIsLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  String convertImageToBase64() {
    return base64Encode(image!);
  }

  RecipeModel buildRecipe(BuildContext ctx) {
    return RecipeModel(
      householdId: Global.getCurrentHousehold(ctx).householdId,
      creatorId: Global.getCurrentUser(ctx).userId!,
      name: recipeName.text.trim(),
      desctiption: description.text.trim(),
      displayImage: convertImageToBase64(),
      cookingTime: int.parse(cookingTimeController.text.trim()),
      makePublic: makePublic,
      createdAt: createdAt,
      categories: <String>[],
      ingredients: ingredients,
      cookingSteps: cookingSteps,
    );
  }

  void setMakePublic(bool newValue) {
    _makePublic = newValue;
    notifyListeners();
  }

  void setImage(Uint8List newImage) {
    _image = newImage;
    notifyListeners();
  }

  void removeImage() {
    _image = null;
    notifyListeners();
  }

  void addCookingStep(CookingStepModel newStep) {
    _cookingSteps = <CookingStepModel>[...cookingSteps, newStep];
    notifyListeners();
  }

  void removeCookingStep() {}

  void addIngredient(Ingredients newIngredient) {
    _ingredients = <Ingredients>[...ingredients, newIngredient];
    notifyListeners();
  }
}
