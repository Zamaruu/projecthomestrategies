import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:provider/provider.dart';

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

  void resetFilter(BuildContext context) {
    var ctemp = <int>[];
    var utemp = <int>[];

    for (var u in _users) {
      utemp.add(u.userId!);
    }

    for (var c in _categories) {
      ctemp.add(c.billCategoryId!);
    }

    _selectedCategories = ctemp;
    _selectedUsers = utemp;

    notifyListeners();
    context.read<BillingState>().setBillsToStandard();
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

  void setFilterForUser(int id, BuildContext context) {
    if (selectedUsersContainsId(id)) {
      var index = _selectedUsers.indexOf(id);
      _selectedUsers.removeAt(index);
    } else {
      _selectedUsers = [...selectedUsers, id];
    }

    notifyListeners();
    filterBills(context);
  }

  void setFilterForCategories(int id, BuildContext context) {
    if (selectedCategoriesContainsId(id)) {
      var index = _selectedCategories.indexOf(id);
      _selectedCategories.removeAt(index);
    } else {
      _selectedCategories = [...selectedCategories, id];
    }

    notifyListeners();
    filterBills(context);
  }

  String getCurrentUserFilterCount() {
    return "${_selectedUsers.length} / ${users.length}";
  }

  String getCurrentCategoryFilterCount() {
    return "${_selectedCategories.length} / ${categories.length}";
  }

  void filterBills(BuildContext context) {
    var bills = context.read<BillingState>().rawBills;

    var filtererdByUsers = bills
        .where(
          (b) => _selectedUsers.contains(b.buyer!.userId),
        )
        .toList();
    var filteredByCategories = filtererdByUsers
        .where(
          (b) => _selectedCategories.contains(b.category!.billCategoryId),
        )
        .toList();

    context.read<BillingState>().setBills(filteredByCategories);
  }
}
