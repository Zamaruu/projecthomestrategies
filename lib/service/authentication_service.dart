import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projecthomestrategies/utils/globals.dart';

class AuthenticationService {
  late String url;

  AuthenticationService(){
    url = Global.baseApiUrl;
  }

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    var rawCredentials = "$email:$password";
    var bytes = utf8.encode(rawCredentials);
    var credentials = base64.encode(bytes);
    
    try {
      final rawUri = url + "/Auth/signin/$credentials";

      final uri = Uri.parse(rawUri);

      var response = await http.post(
        uri,
        headers: Global.baseApiHeader,
      );

      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        return jsonDecode(response.body);  
      }
      else{
        print(response.statusCode);
        return response.statusCode.toString();
      }
      
    } catch (e) {
      rethrow;
    }
  }
}