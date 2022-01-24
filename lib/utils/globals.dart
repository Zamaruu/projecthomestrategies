import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projecthomestrategies/pages/authpages/authenticationhandler.dart';
import 'package:projecthomestrategies/pages/authpages/signinpage.dart';
import 'package:projecthomestrategies/pages/authpages/signuppage.dart';
import 'package:projecthomestrategies/pages/billspage/billspage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:intl/intl.dart';
import 'package:projecthomestrategies/pages/household/householdpage.dart';

class Global {
  static const double splashRadius = 20;
  static const String baseApiUrl = "http://192.168.0.71:5000/api";
  // static const String baseApiUrl = "http://10.0.2.2:5000/api";
  static const Duration timeoutDuration = Duration(milliseconds: 7500);
  static Map<String, String> baseApiHeader = {
    "Accept": "application/json",
    "content-type": "application/json"
  };

  static Map<String, Widget Function(BuildContext)> appRoutes = {
    "/homepage": (context) => const HomePage(),
    "/bills": (context) => BillsPage(),
    "/signin": (context) => const SignInPage(),
    "/signup": (context) => const SignUpPage(),
    "/household": (context) => HouseholdPage(),
    "/auth": (context) => const AuthenticationHander(),
  };

  static void navigateWithOutSamePush(BuildContext context, String nav) {
    Route route = ModalRoute.of(context) as Route;
    final routeName = route.settings.name;

    if (routeName != null && routeName != nav) {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(nav);
    } else {
      Navigator.pop(context);
    }
  }

  static String datetimeToDeString(DateTime date,
      {String format = "dd.MM.yyyy"}) {
    return DateFormat(format).format(date);
  }

  static String encodeCredentials(String email, String password) {
    var rawCredentials = "$email:$password";
    var bytes = utf8.encode(rawCredentials);
    return base64.encode(bytes);
  }

  static bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static Map<String, String> getHeaderWithAuthentication(String token) {
    var header = baseApiHeader;
    header["Authorization"] = "Bearer $token";
    return header;
  }
}
