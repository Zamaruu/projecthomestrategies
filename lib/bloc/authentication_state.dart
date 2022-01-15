import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/service/authentication_service.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class AuthenticationState with ChangeNotifier {
  late UserModel? user;
  late String token;
  // ignore: prefer_final_fields
  Status _status = Status.uninitialized;
  Status get status => _status;

  //Authentication methods
  Future<bool> signIn(String email, String password) async {
    var response = await AuthenticationService().signInWithEmailAndPassword(email, password);

    if(response == null){
      print(response);
      return false;
    }
    
    _status = Status.authenticated;
    token = response;

    notifyListeners();

    return true;
  }

  void signOut(){
    user = null;
    token = "";
    _status = Status.unauthenticated;
    notifyListeners();
  }
}