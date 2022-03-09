import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class BillFilterState with ChangeNotifier {
  // Raw data
  late List<UserModel> _users;
  List<UserModel> get users => _users;
  late List<BillCategoryModel> _categories;
  List<BillCategoryModel> get categories => _categories;

  //Filter data
  late List<int> _selectedUsers;
  List<int> get selectedUsers => _selectedUsers;
  late List<int> _selectedCategories;
  List<int> get selectedCategories => _selectedCategories;

  void initFilter({
    required List<UserModel> users,
    required List<BillCategoryModel> categories,
  }) {
    _users = users;
    _categories = categories;

    _selectedUsers = setSelectedUsersToStandart();
    _selectedCategories = setSelectedCategoriesToStandart();
  }

  List<int> setSelectedUsersToStandart({bool notify = false}) {
    var temp = <int>[];

    for (var u in _users) {
      temp.add(u.userId!);
    }

    if (notify) {
      notifyListeners();
      return [];
    } else {
      return temp;
    }
  }

  List<int> setSelectedCategoriesToStandart({bool notify = false}) {
    var temp = <int>[];

    for (var c in _categories) {
      temp.add(c.billCategoryId!);
    }

    if (notify) {
      notifyListeners();
      return [];
    } else {
      return temp;
    }
  }

  bool selectedUsersContainsId(int id) {
    return selectedUsers.contains(id);
  }

  bool selectedCategoriesContainsId(int id) {
    return selectedCategories.contains(id);
  }

  void setFilterForUser(int id) {
    if (selectedUsersContainsId(id)) {
      var index = _selectedUsers.indexOf(id);
      _selectedUsers.removeAt(index);
    } else {
      _selectedUsers = [...selectedUsers, id];
    }
    notifyListeners();
  }

  void setFilterForCategories(int id) {
    if (selectedCategoriesContainsId(id)) {
      var index = _selectedCategories.indexOf(id);
      _selectedCategories.removeAt(index);
    } else {
      _selectedCategories = [...selectedCategories, id];
    }
    notifyListeners();
  }
}
