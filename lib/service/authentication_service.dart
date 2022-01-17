import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class AuthenticationService {
  late String url;

  AuthenticationService(){
    url = Global.baseApiUrl;
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword({String? email, String? password, String? encodedCredentials}) async {
    String credentials = "";

    if(encodedCredentials != null){
      credentials = encodedCredentials;
    }
    else{
      credentials = Global.encodeCredentials(email!, password!);
    }
    
    try {
      final rawUri = url + "/Auth/signin/$credentials";

      final uri = Uri.parse(rawUri);

      var response = await http.post(
        uri,
        headers: Global.baseApiHeader,
      );

      if(response.statusCode == 200 || response.statusCode == 307){
        if(response.body.isEmpty){
          return <String, dynamic>{
            "code": 500,
            "token": null,
          }; 
        }

        //getting auth token
        var body = jsonDecode(response.body);

        return <String, dynamic>{
          "code": response.statusCode,
          "token": body["token"],
          "user": UserModel.fromJson(body["user"]),
        };  
      }
      else{
        return <String, dynamic>{
          "code": response.statusCode,
          "token": null
        }; 
      }
      
    } catch (e) {
      rethrow;
      return <String, dynamic>{
        "code": 500,
        "token": null
      }; 
    }
  }
}