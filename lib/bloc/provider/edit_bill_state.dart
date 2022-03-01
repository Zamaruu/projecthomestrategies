import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class EditBillState extends ChangeNotifier {
  late BillModel _bill;
  BillModel get bill => _bill;
  late bool _isEditing;
  bool get isEditing => _isEditing;

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
  late List<BillImageModel> _images;
  List<BillImageModel> get images => _images;

  late bool _isLoading;
  bool get isLoading => _isLoading;

  EditBillState(BillModel editBill, int _selectedCategory) {
    _bill = editBill;
    _isEditing = false;

    _isLoading = false;
    _categorySelection = _selectedCategory;
    _selectedDate = editBill.date!;
    _images = editBill.images!;

    _selectedDateController = TextEditingController(
      text: Global.datetimeToDeString(_selectedDate),
    );
    _moneySumController = TextEditingController(
      text: editBill.amount!.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: editBill.description ?? "",
    );
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

  void addImageToList(List<BillImageModel> image) {
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
