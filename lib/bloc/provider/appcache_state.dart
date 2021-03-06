// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/notifcationmodel.dart';

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

  //Notifications
  int countOpenNotifications() {
    return _openNotifications.length;
  }

  int countNotifications() {
    return _openNotifications.length + _seenNotifications.length;
  }

  void deleteAllNotifications() {
    _openNotifications = <NotificationModel>[];
    _seenNotifications = <NotificationModel>[];
    notifyListeners();
  }

  void setInitialNotificationData(
    List<NotificationModel> open,
    List<NotificationModel> seen,
  ) {
    _openNotifications = open;
    _seenNotifications = seen;
  }

  void setNotificationToSeen(NotificationModel notification,
      {bool notify = true}) {
    int index = _openNotifications.indexWhere(
      (n) => n.notificationId == notification.notificationId,
    );

    if (index == -1) {
      return;
    } else {
      var _notification = _openNotifications
          .where(
            (n) => n.notificationId == notification.notificationId,
          )
          .first;
      _notification.seen = true;
      _openNotifications.removeAt(index);
      _seenNotifications = [..._seenNotifications, _notification];

      if (notify) {
        notifyListeners();
      }
    }
  }

  void setAllOpenNotificationsToSeen() {
    var open = _openNotifications;
    _openNotifications = List<NotificationModel>.empty();

    for (var notification in open) {
      setNotificationToSeen(notification);
    }

    notifyListeners();
  }

  void setOpenNotifications(List<NotificationModel> openNotfications) {
    _openNotifications = openNotfications;
    notifyListeners();
  }

  List<NotificationModel> sortNotifications(
    List<NotificationModel> notifications,
  ) {
    notifications.sort((a, b) {
      var adate = a.created!; //before -> var adate = a.expiry;
      var bdate = b.created!; //before -> var bdate = b.expiry;
      return bdate.compareTo(
        adate,
      ); //to get the order other way just switch `adate & bdate`
    });

    return notifications;
  }

  // Bills
  void setBills(List<BillModel> bills, {bool notify = true}) {
    _bills = bills;

    if (notify) {
      notifyListeners();
    }
  }

  void setBillCategories(List<BillCategoryModel> categories,
      {bool notify = true}) {
    _billCategories = categories;

    if (notify) {
      notifyListeners();
    }
  }

  bool billingContentIsSet() {
    if (_bills.isNotEmpty && _billCategories.isNotEmpty) {
      return true;
    }
    return false;
  }
}
