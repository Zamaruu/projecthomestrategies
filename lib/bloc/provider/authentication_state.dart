import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/service/authentication_service.dart';
import 'package:projecthomestrategies/utils/securestoragehandler.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class AuthenticationState with ChangeNotifier {
  late UserModel sessionUser;
  late String token;
  // ignore: prefer_final_fields
  Status _status = Status.uninitialized;
  Status get status => _status;

  //Authentication methods
  Future<int> signIn(
      {String? email, String? password, String? encodedCredentials}) async {
    Map<String, dynamic> response;

    if (encodedCredentials != null) {
      response = await AuthenticationService()
          .signInWithEmailAndPassword(encodedCredentials: encodedCredentials);
    } else {
      response = await AuthenticationService()
          .signInWithEmailAndPassword(email: email, password: password);
    }

    if (response["code"] == 200 || response["code"] == 307) {
      try {
        _status = Status.authenticated;

        token = response["token"];
        sessionUser = response["user"];

        notifyListeners();
        return response["code"];
      } catch (e) {
        return 500;
      }
    }

    _status = Status.unauthenticated;
    notifyListeners();
    return response["code"];
  }

  Future<int> signInWithSavedCredentials(String credetials) async {
    return signIn(encodedCredentials: credetials);
  }

  Future<void> signOut() async {
    sessionUser = UserModel();
    token = "";
    await SecureStorageHandler().signOutCurrentUser();
    _status = Status.unauthenticated;
    notifyListeners();
  }

  void addHouseholdToSessionUser(HouseholdModel household) {
    sessionUser.household = household;
    notifyListeners();
  }
}
