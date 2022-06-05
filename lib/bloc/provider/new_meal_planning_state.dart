import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class NewMealPlanningState with ChangeNotifier {
  late bool _isSearchModalOpen;
  bool get isSearchModalOpen => _isSearchModalOpen;
  late bool _isLoading;
  bool get isLoading => _isLoading;

  late FullRecipeModel? _selectedRecipe;
  FullRecipeModel? get selectedRecipe => _selectedRecipe;
  late TextEditingController? _basicRecipeNameController;
  TextEditingController? get basicRecipeNameController =>
      _basicRecipeNameController;

  late DateTime _startDate;
  DateTime get startDate => _startDate;
  late DateTime _endDate;
  DateTime get endDate => _endDate;

  late Color _color;
  Color get color => _color;

  NewMealPlanningState() {
    _isLoading = false;
    _isSearchModalOpen = false;
    _selectedRecipe = null;
    _basicRecipeNameController = TextEditingController();
    _basicRecipeNameController!.addListener(() {
      notifyListeners();
    });
    _startDate = DateTime.now().toLocal();
    _endDate = DateTime.now().add(const Duration(days: 1)).toLocal();
    _color = Colors.blue;
  }

  PlannedMealModel buildMealPlanning(BuildContext ctx) {
    return PlannedMealModel(
      plannedMealId: 0,
      creator: Global.getCurrentUser(ctx),
      household: Global.getCurrentHousehold(ctx),
      startDay: startDate,
      endDay: endDate,
      color: color.value,
      recipe: selectedRecipe,
      basicRecipeName: basicRecipeNameController!.text,
    );
  }

  bool isPlanningValid() {
    if (_selectedRecipe == null &&
        Global.isStringNullOrEmpty(_basicRecipeNameController!.text)) {
      return false;
    }
    if (endDate.isBefore(startDate)) {
      return false;
    }
    return true;
  }

  void setIsSearchModalOpen(bool value) {
    _isSearchModalOpen = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = true;
    notifyListeners();
  }

  //Rezept
  void setRecipe(FullRecipeModel recipe) {
    _selectedRecipe = recipe;
    notifyListeners();
  }

  void removeRecipe() {
    _selectedRecipe = null;
    notifyListeners();
  }

  //Daten
  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  //Color
  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
}
