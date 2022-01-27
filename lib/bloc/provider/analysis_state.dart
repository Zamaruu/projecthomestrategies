import 'package:flutter/cupertino.dart';

class AnalysisState with ChangeNotifier {
  late DateTime _startDate;
  DateTime get startDate => _startDate;
  late DateTime _endDate;
  DateTime get endDate => _endDate;

  AnalysisState(this._startDate, this._endDate);

  void setStartDate(DateTime newStart) {
    _startDate = newStart; //.subtract(const Duration(minutes: 10));
    notifyListeners();
  }

  void setEndDate(DateTime newEnd) {
    _endDate = newEnd; //.add(const Duration(minutes: 10));
    notifyListeners();
  }
}
