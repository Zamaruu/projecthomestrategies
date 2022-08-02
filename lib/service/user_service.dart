import 'dart:async';
import 'dart:convert';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String token;
  late String url;
  late Map<String, String> header;

  UserService(this.token) {
    url = Global.baseApiUrl;
    header = Global.getHeaderWithAuthentication(token);
  }

  Future<ApiResponseModel> getMe() async {
    try {
      final rawUri = url + "/User/Me?includeDetails=true";

      final uri = Uri.parse(rawUri);

      var response = await http
          .get(
            uri,
            headers: header,
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          UserModel.fromJson(jsonDecode(response.body)),
        );
      } else {
        return ApiResponseModel.error(
          response.statusCode,
          response.body.isNotEmpty ? response.body : response.reasonPhrase,
        );
      }
    } on TimeoutException catch (e) {
      return ApiResponseModel.error(408, e.message.toString());
    } on Exception catch (e) {
      return ApiResponseModel.error(500, e.toString());
    }
  }
}
