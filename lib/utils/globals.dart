import 'package:flutter/material.dart';
import 'package:projecthomestrategies/pages/billspage/billspage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:intl/intl.dart';

class Global {
  static double splashRadius = 20;

  static Map<String, Widget Function(BuildContext)> appRoutes = {
    "/homepage": (context) => const HomePage(),
    "/bills": (context) => BillsPage(),
  };

  static void navigateWithOutSamePush(BuildContext context, String nav){
    Route route = ModalRoute.of(context) as Route;
    final routeName = route.settings.name;
    
    if (routeName != null && routeName != nav) {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(nav);
    }
    else{
      Navigator.pop(context);
    }
  }

  static String datetimeToDeString(DateTime date, {String format = "dd.MM.yyyy"}){
    return DateFormat(format).format(date);
  }
}