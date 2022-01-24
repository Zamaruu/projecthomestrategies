import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';

class BillingState with ChangeNotifier {
  late List<BillCategoryModel> _billCategories;
  List<BillCategoryModel> get billCategories => _billCategories;
  late List<BillModel> _bills;
  List<BillModel> get bills => _bills;

  BillingState(List<BillCategoryModel> billCategories, List<BillModel> bills) {
    _billCategories = billCategories;
    _bills = bills;
  }

  bool isEmpty() {
    return _billCategories.isEmpty && _bills.isEmpty;
  }

  void setInitialData(
    List<BillCategoryModel> billCategories,
    List<BillModel> bills,
  ) {
    _billCategories = billCategories;
    _bills = bills;
    notifyListeners();
  }
}
