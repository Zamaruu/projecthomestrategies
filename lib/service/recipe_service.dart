import 'dart:async';
import 'dart:convert';

import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  late String url;
  final String token;
  late Map<String, String> header;

  RecipeService(this.token) {
    url = Global.baseApiUrl;
    header = Global.getHeaderWithAuthentication(token);
  }

  Future<ApiResponseModel> getRecipesBasic({
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final rawUri = url + "/Recipe/Public";

      final uri = Uri.parse(rawUri);

      var response = await http
          .get(
            uri,
            headers: header,
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);

        return ApiResponseModel.success(
          response.statusCode,
          List<FullRecipeModel>.from(
            jsonBody.map((model) => FullRecipeModel.fromJson(model)),
          ),
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
