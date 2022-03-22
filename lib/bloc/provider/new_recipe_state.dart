import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class NewRecipeState with ChangeNotifier {
  late int _householdId;
  int get householdId => _householdId;
  late int _creatorId;
  int get creatorId => _creatorId;
  late String _recipeName;
  String get recipeName => _recipeName;
  late String _description;
  String get description => _description;
  late Uint8List? _image;
  Uint8List? get image => _image;
  late int _cookingTime;
  int get cookingTime => _cookingTime;
  late bool _makePublic;
  bool get makePublic => _makePublic;
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;
  late List<CookingStepModel> _cookingSteps;
  List<CookingStepModel> get cookingSteps => _cookingSteps;

  NewRecipeState() {
    _householdId = 0;
    _creatorId = 0;
    _recipeName = "";
    _description = "";
    _image = null;
    _cookingTime = 0;
    _makePublic = false;
    _createdAt = DateTime.now().toLocal();
    _cookingSteps = <CookingStepModel>[];
  }

  String convertImageToBase64() {
    return base64Encode(image!);
  }

  RecipeModel buildRecipe(BuildContext ctx) {
    return RecipeModel(
      householdId:
          ctx.read<AuthenticationState>().getSessionHousehold()!.householdId!,
      creatorId: Global.getCurrentUser(ctx).userId!,
      name: recipeName,
      desctiption: description,
      displayImage: convertImageToBase64(),
      cookingTime: cookingTime,
      makePublic: makePublic,
      createdAt: createdAt,
      cookingSteps: cookingSteps,
    );
  }

  void setImage(Uint8List newImage) {
    _image = newImage;
    notifyListeners();
  }

  void removeImage() {
    _image = null;
    notifyListeners();
  }
}
