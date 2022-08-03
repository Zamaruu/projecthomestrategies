import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class SettingsService {
  final String token;
  late String url;
  late Map<String, String> header;

  SettingsService(this.token) {
    url = Global.baseApiUrl;
    header = Global.getHeaderWithAuthentication(token);
  }

  Future<ApiResponseModel> editUser(int id, int color) async {
    try {
      final rawUri = url + "/User/Color?userId=$id&color=$color";

      final uri = Uri.parse(rawUri);

      var response = await http
          .put(
            uri,
            headers: header,
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          response.body,
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
