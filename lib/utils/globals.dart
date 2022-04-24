import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/pages/billspage/billpagebuilder.dart';
import 'package:projecthomestrategies/pages/homepage/initialloader.dart';
import 'package:projecthomestrategies/pages/homepage/notificationdialog.dart';
import 'package:projecthomestrategies/pages/recipes/recipebuilder.dart';
import 'package:projecthomestrategies/pages/settings/settingspage.dart';
import 'package:projecthomestrategies/widgets/auth/authorentication_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/authenticationhandler.dart';
import 'package:projecthomestrategies/pages/authpages/signinpage.dart';
import 'package:projecthomestrategies/pages/authpages/signuppage.dart';
import 'package:intl/intl.dart';
import 'package:projecthomestrategies/pages/household/householdpage.dart';

class Global {
  static const double splashRadius = 20;
  static const String baseApiUrl = kDebugMode
      //? "http://192.168.0.143:5000/api" //Local Ubuntu VM
      ? "http://192.168.0.71:5000/api" //Local Windows Docker
      : "http://194.163.182.236:5000/api"; //Live Production API and DB
  // static const String baseApiUrl = "http://10.0.2.2:5000/api";
  static const Duration timeoutDuration = Duration(milliseconds: 15000);
  static Map<String, String> baseApiHeader = {
    "Accept": "application/json",
    "content-type": "application/json"
  };

  static Map<String, Widget Function(BuildContext)> appRoutes = {
    "/homepage": (context) => const InitialLoader(),
    "/bills": (context) => const BillContentBuilder(),
    "/signin": (context) => const SignInPage(),
    "/signup": (context) => const SignUpPage(),
    "/household": (context) => HouseholdPage(),
    "/recipes": (context) => const RecipeBuilder(),
    "/auth": (context) => const AuthenticationHander(),
    "/notifications": (context) => const NotificationDialog(),
    "/settings": (context) => const SettingsPage(),
  };

  static Map<String, Widget> staticAppRoutes = {
    "/homepage": const InitialLoader(),
    "/bills": const BillContentBuilder(),
    "/signin": const SignInPage(),
    "/signup": const SignUpPage(),
    "/household": HouseholdPage(),
    "/recipes": const RecipeBuilder(),
    "/auth": const AuthenticationHander(),
    "/notifications": const NotificationDialog(),
    "/settings": const SettingsPage(),
  };

  static void navigateWithOutSamePush(
    BuildContext context,
    String nav, {
    bool shouldPop = true,
  }) {
    Route route = ModalRoute.of(context) as Route;
    final routeName = route.settings.name;

    if (routeName != null && routeName != nav) {
      if (shouldPop) {
        Navigator.pop(context);
      }
      Navigator.of(context).pushNamed(nav);
    } else {
      Navigator.pop(context);
    }
  }

  static void navigateWithNavigatorKey(
    GlobalKey<NavigatorState> key,
    String nav,
  ) {
    key.currentState!.push(
      MaterialPageRoute(
        builder: (context) => AuthenticationWrapper(
          child: staticAppRoutes[key]!,
        ),
      ),
    );
    //key.currentState!.pushNamed(nav);
  }

  static String datetimeToDeString(DateTime date,
      {String format = "dd.MM.yyyy"}) {
    return DateFormat(format).format(date);
  }

  static bool isDateInRange(DateTime start, DateTime end, DateTime date) {
    return start.isBefore(date) && end.isAfter(date);
  }

  static DateTime cutTimeFromDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
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

  static String removeQuotationMarksFromString(String text) {
    return text.replaceAll('"', "");
  }

  static String getToken(BuildContext context) {
    return context.read<AuthenticationState>().token;
  }

  static UserModel getCurrentUser(BuildContext context) {
    return context.read<AuthenticationState>().sessionUser;
  }

  static bool isStringNullOrEmpty(String? s) {
    return s == null || s.isEmpty;
  }
}
