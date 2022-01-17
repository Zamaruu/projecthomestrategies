import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/service/authentication_service.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class AuthenticationState with ChangeNotifier {
  late UserModel? sessionUser;
  late String token;
  // ignore: prefer_final_fields
  Status _status = Status.uninitialized;
  Status get status => _status;

  //Authentication methods
  Future<int> signIn(String email, String password) async {
    Map<String, dynamic> response = await AuthenticationService().signInWithEmailAndPassword(email, password);

    if(response["code"] == 200 || response["code"] == 307){
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

  void signOut(){
    sessionUser = null;
    token = "";
    _status = Status.unauthenticated;
    notifyListeners();
  }
}