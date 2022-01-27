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
    List<BillModel> bills, {
    bool notify = false,
  }) {
    _billCategories = billCategories;
    _bills = bills;
    if (notify) {
      notifyListeners();
    }
  }

  void addBillCategory(BillCategoryModel newCategory) {
    _billCategories = [..._billCategories, newCategory];
    notifyListeners();
  }

  void addBill(BillModel newBill) {
    _bills = [..._bills, newBill];
    notifyListeners();
  }

  DateTime getOldestDate() {
    var dates = List.generate(_bills.length, (index) => _bills[index].date!);
    return dates
        .reduce((a, b) => a.isBefore(b) ? a : b)
        .subtract(const Duration(minutes: 10));
  }

  DateTime getNewestDate() {
    var dates = List.generate(_bills.length, (index) => _bills[index].date!);
    return dates
        .reduce((a, b) => a.isAfter(b) ? a : b)
        .add(const Duration(minutes: 10));
  }
}
