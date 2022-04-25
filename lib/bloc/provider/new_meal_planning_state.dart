import 'package:flutter/cupertino.dart';

class NewMealPlanningState with ChangeNotifier {
  late bool _isSearchModalOpen;
  bool get isSearchModalOpen => _isSearchModalOpen;

  NewMealPlanningState() {
    _isSearchModalOpen = false;
  }

  void setIsSearchModalOpen(bool value) {
    _isSearchModalOpen = value;
    notifyListeners();
  }
}
