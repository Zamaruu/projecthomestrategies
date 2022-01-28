import 'package:flutter/foundation.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';

class AppCacheState with ChangeNotifier {
  late final List<NotificationModel> _openNotifications;
  List<NotificationModel> get openNotificaions => _openNotifications;
  late final List<NotificationModel> _seenNotifications;
  List<NotificationModel> get seenNotificaions => _seenNotifications;
  late final List<BillModel> _bills;
  List<BillModel> get bills => _bills;
  late final List<BillCategoryModel> _billCategories;
  List<BillCategoryModel> get billCategories => _billCategories;

  AppCacheState(
    this._openNotifications,
    this._seenNotifications,
    this._bills,
    this._billCategories,
  );

  int countOpenNotifications() {
    return _openNotifications.length;
  }
}
