import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class NewBillState extends ChangeNotifier {
  late TextEditingController _moneySumController;
  TextEditingController get moneySumController => _moneySumController;
  late TextEditingController _selectedDateController;
  TextEditingController get selectedDateController => _selectedDateController;
  late TextEditingController _descriptionController;
  TextEditingController get descriptionController => _descriptionController;
  late int _categorySelection;
  int get categorySelection => _categorySelection;
  late DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;

  NewBillState() {
    _categorySelection = 0;
    _selectedDate = DateTime.now().toLocal();
    _selectedDateController = TextEditingController(
      text: Global.datetimeToDeString(_selectedDate),
    );
    _moneySumController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void setCategorySelection(int category) {
    _categorySelection = category;
    notifyListeners();
  }

  void setSelectedDate(DateTime picked) {
    _selectedDate = picked;
    _selectedDateController.text = Global.datetimeToDeString(picked);
    notifyListeners();
  }
}
