import 'package:projecthomestrategies/bloc/models/user_model.dart';

class AuthenticationModel {
  final String token;
  final UserModel user;

  AuthenticationModel({required this.token, required this.user});
}
