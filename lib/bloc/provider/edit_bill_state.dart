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
  final int maxImages = 3;

  late TextEditingController _moneySumController;
  TextEditingController get moneySumController => _moneySumController;
  late TextEditingController _selectedDateController;
  TextEditingController get selectedDateController => _selectedDateController;
  late TextEditingController _descriptionController;
  TextEditingController get descriptionController => _descriptionController;

  late int _initialCategorySelection;
  late int _categorySelection;
  int get categorySelection => _categorySelection;
  late DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;
  late List<BillImageModel> _images;
  List<BillImageModel> get images => _images;
  late List<int> _imagesToDelete;
  List<int> get imagesToDelete => _imagesToDelete;

  late bool _isLoading;
  bool get isLoading => _isLoading;

  EditBillState(BillModel editBill, int _selectedCategory) {
    _bill = editBill;
    _isEditing = false;

    _isLoading = false;
    _categorySelection = _selectedCategory;
    _initialCategorySelection = _selectedCategory;
    _selectedDate = editBill.date!;
    _images = editBill.images!;
    _imagesToDelete = <int>[];

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
    if (images.length < 3) {
      _images = [..._images, ...image];
      notifyListeners();
    }
  }

  void addImageToDelete(int imageId) {
    _imagesToDelete = [..._imagesToDelete, imageId];
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

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void setBillWhenEdited(BillModel editedBill) {
    _bill = editedBill;
    notifyListeners();
  }

  void resetEditState() {
    _categorySelection = _initialCategorySelection;
    _selectedDate = _bill.date!;
    _images = _bill.images!;

    _selectedDateController.text = Global.datetimeToDeString(_selectedDate);
    _moneySumController.text = _bill.amount!.toStringAsFixed(2);
    _descriptionController.text = _bill.description ?? "";

    notifyListeners();
  }
}
