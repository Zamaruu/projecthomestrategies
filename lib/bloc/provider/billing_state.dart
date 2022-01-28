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

  void setBills(List<BillModel> newBills) {
    _bills = newBills;
    notifyListeners();
  }

  void setBillCategories(List<BillCategoryModel> newCategories) {
    _billCategories = newCategories;
    notifyListeners();
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

  void addBill(BillModel newBill) {
    _bills = [..._bills, newBill];
    notifyListeners();
  }

  void editBill(BillModel bill) {
    int index = _bills.indexWhere(
      (b) => b.billId == bill.billId,
    );

    if (index == -1) {
      return;
    } else {
      _bills[index].category = bill.category;
      _bills[index].amount = bill.amount;
      _bills[index].date = bill.date;
      notifyListeners();
    }
  }

  void removeBill(BillModel bill) {
    int index = _bills.indexWhere(
      (b) => b.billId == bill.billId,
    );
    if (index == -1) {
      return;
    } else {
      _bills.removeAt(index);
      notifyListeners();
    }
  }

  void addBillCategory(BillCategoryModel newCategory) {
    _billCategories = [..._billCategories, newCategory];
    notifyListeners();
  }

  void editBillCategory(BillCategoryModel category) {
    int index = _billCategories.indexWhere(
      (bc) => bc.billCategoryId == category.billCategoryId,
    );

    if (index == -1) {
      return;
    } else {
      _billCategories[index].billCategoryName = category.billCategoryName;
      notifyListeners();
    }
  }

  void removeBillCategory(BillCategoryModel category) {
    int index = _billCategories
        .indexWhere((bc) => bc.billCategoryId == category.billCategoryId);
    if (index == -1) {
      return;
    } else {
      _billCategories.removeAt(index);
      notifyListeners();
    }
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
