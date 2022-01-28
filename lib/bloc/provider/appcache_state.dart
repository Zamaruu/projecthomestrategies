// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';

class AppCacheState with ChangeNotifier {
  late List<NotificationModel> _openNotifications;
  List<NotificationModel> get openNotificaions => _openNotifications;
  late List<NotificationModel> _seenNotifications;
  List<NotificationModel> get seenNotificaions => _seenNotifications;
  late List<BillModel> _bills;
  List<BillModel> get bills => _bills;
  late List<BillCategoryModel> _billCategories;
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

  int countNotifications() {
    return _openNotifications.length + _seenNotifications.length;
  }

  void setInitialNotificationData(
    List<NotificationModel> open,
    List<NotificationModel> seen,
  ) {
    _openNotifications = open;
    _seenNotifications = seen;
  }
}
