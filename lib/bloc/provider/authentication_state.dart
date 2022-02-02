import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/authentication_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
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
  Future<ApiResponseModel> signIn(
      {String? email, String? password, String? encodedCredentials}) async {
    ApiResponseModel response;

    if (encodedCredentials != null) {
      response = await AuthenticationService()
          .signInWithEmailAndPassword(encodedCredentials: encodedCredentials);
    } else {
      response = await AuthenticationService()
          .signInWithEmailAndPassword(email: email, password: password);
    }

    if (response.statusCode == 200 || response.statusCode == 307) {
      try {
        _status = Status.authenticated;

        AuthenticationModel auth = response.object as AuthenticationModel;

        token = auth.token;
        sessionUser = auth.user;

        notifyListeners();
        return response;
      } catch (e) {
        return ApiResponseModel.error(500, e.toString());
      }
    }

    _status = Status.unauthenticated;
    notifyListeners();
    return response;
  }

  Future<ApiResponseModel> signInWithSavedCredentials(String credetials) async {
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

  bool isUserPartOfHousehold() {
    return sessionUser.household == null;
  }
}
