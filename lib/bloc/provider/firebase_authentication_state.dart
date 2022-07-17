import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class FirebaseAuthenticationState with ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  late UserModel sessionUser;

  //FirebaseAuth instance
  FirebaseAuthenticationState(this.firebaseAuth);
  //Constuctor to initalize the FirebaseAuth instance

  //Using Stream to listen to Authentication State
  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  //............RUDIMENTARY METHODS FOR AUTHENTICATION................

  //SIGN UP METHOD
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  //SIGN IN METHOD
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// Get Token for current User Session
  Future<String> getToken() async {
    final user = await firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    } else {
      return "";
    }
  }

  // --------------------------------------------------
  // Custom Methods
  bool isUserPartOfHousehold() {
    return sessionUser.household == null;
  }

  HouseholdModel? getSessionHousehold() {
    return sessionUser.household;
  }

  void setUser(UserModel newUser) {
    sessionUser = newUser;
    notifyListeners();
  }
}
