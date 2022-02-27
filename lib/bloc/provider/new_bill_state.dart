import 'dart:io';

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
  late List<File> _images;
  List<File> get images => _images;

  late bool _isLoading;
  bool get isLoading => _isLoading;

  NewBillState() {
    _isLoading = false;
    _categorySelection = 0;
    _selectedDate = DateTime.now().toLocal();
    _images = <File>[];
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

  void addImageToList(File image) {
    _images = [..._images, image];
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
