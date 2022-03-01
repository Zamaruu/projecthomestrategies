import 'dart:typed_data';
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
  late List<Uint8List> _images;
  List<Uint8List> get images => _images;

  late bool _isLoading;
  bool get isLoading => _isLoading;

  NewBillState() {
    _isLoading = false;
    _categorySelection = 0;
    _selectedDate = DateTime.now().toLocal();
    _images = <Uint8List>[];
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

  void addImageToList(List<Uint8List> image) {
    _images = [..._images, ...image];
    notifyListeners();
  }

  void removeImageFromList(int index) {
    _images.removeAt(index);
    //_images = [..._images];
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
