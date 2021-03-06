import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';

class BillingState with ChangeNotifier {
  final int _pageSize = 50;
  int get pageSize => _pageSize;
  late int _pageCount;
  int get pageCount => _pageCount;
  late List<BillCategoryModel> _rawCategories;
  late List<BillCategoryModel> _billCategories;
  List<BillCategoryModel> get billCategories => _billCategories;
  late List<BillModel> _rawBills;
  List<BillModel> get rawBills => _rawBills;
  late List<BillModel> _bills;
  List<BillModel> get bills => _bills;

  BillingState(List<BillCategoryModel> billCategories, List<BillModel> bills) {
    _billCategories = billCategories;
    _rawCategories = [];
    _bills = bills;
    _rawBills = [];
    _pageCount = 1;
  }

  bool isEmpty() {
    return _billCategories.isEmpty && _bills.isEmpty;
  }

  void setBillsToStandard() {
    _bills = _rawBills;
    notifyListeners();
  }

  void setBills(List<BillModel> newBills) {
    _bills = newBills;
    notifyListeners();
  }

  void addBills(List<BillModel> newBills) {
    _bills = [..._bills, ...newBills];
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
    _rawBills = bills;
    _pageCount = 1;
    if (notify) {
      notifyListeners();
    }
  }

  void addBill(BillModel newBill) {
    _bills = [..._bills, newBill];
    _rawBills = _bills;
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
      _rawBills = _bills;
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
      _rawBills = _bills;
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

  void setPageCount(int newPage) {
    _pageCount = newPage;
    notifyListeners();
  }

  bool canLoadMore() {
    return _bills.length >= _pageSize;
  }
}
