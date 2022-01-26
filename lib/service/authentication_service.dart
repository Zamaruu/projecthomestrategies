import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/authentication_model.dart';
import 'package:projecthomestrategies/bloc/signup_model.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class AuthenticationService {
  late String url;

  AuthenticationService() {
    url = Global.baseApiUrl;
  }

  Future<ApiResponseModel> signInWithEmailAndPassword({
    String? email,
    String? password,
    String? encodedCredentials,
  }) async {
    String credentials = "";

    if (encodedCredentials != null) {
      credentials = encodedCredentials;
    } else {
      credentials = Global.encodeCredentials(email!, password!);
    }

    try {
      final rawUri = url + "/Auth/signin/$credentials";

      final uri = Uri.parse(rawUri);

      var response = await http
          .post(
            uri,
            headers: Global.baseApiHeader,
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 307) {
        if (response.body.isEmpty) {
          return ApiResponseModel.error(
            response.statusCode,
            "Die Antwort des Servers ist Fehelerhaft",
          );
        }

        //getting auth token
        var body = jsonDecode(response.body);

        return ApiResponseModel.success(
          response.statusCode,
          AuthenticationModel(
            token: body["token"],
            user: UserModel.fromJson(body["user"]),
          ),
        );
      } else {
        return ApiResponseModel.error(response.statusCode, response.body);
      }
    } on TimeoutException catch (e) {
      return ApiResponseModel.error(408, e.toString());
    } on Exception catch (e) {
      return ApiResponseModel.error(500, e.toString());
    }
  }

  Future<ApiResponseModel> signUpWithEmailAndPassword(
      SignupModel signupModel) async {
    try {
      final rawUri = url + "/Auth/signup/basic";

      final uri = Uri.parse(rawUri);

      var response = await http
          .post(
            uri,
            headers: Global.baseApiHeader,
            body: jsonEncode(signupModel.toJson()),
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 201) {
        return ApiResponseModel.success(response.statusCode, null);
      } else {
        return ApiResponseModel.error(response.statusCode, response.body);
      }
    } on TimeoutException catch (e) {
      return ApiResponseModel.error(408, e.toString());
    } on Exception catch (e) {
      return ApiResponseModel.error(500, e.toString());
    }
  }
}
