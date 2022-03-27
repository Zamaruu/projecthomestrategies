import 'dart:async';
import 'dart:convert';

import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
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
    int pageSize = 25,
  }) async {
    try {
      final rawUri =
          url + "/Recipe/Public?pageNumber=$pageNumber&pageSize=$pageSize";

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

  Future<ApiResponseModel> getSingleRecipe(String id) async {
    try {
      final rawUri = url + "/Recipe/$id";

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
          FullRecipeModel.fromJson(jsonBody),
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

  Future<ApiResponseModel> createNewRecipe(RecipeModel recipe) async {
    try {
      final rawUri = url + "/Recipe";

      final uri = Uri.parse(rawUri);

      var response = await http
          .post(
            uri,
            headers: header,
            body: jsonEncode(recipe.toJson()),
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

  // ---------------------------------------------------------------------------
  // Favoriten

  Future<ApiResponseModel> getFavouriteRecipes({
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final rawUri = url + "/Recipe/Favourites";

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

  Future<ApiResponseModel> setRecipeAsFavourite(String id) async {
    try {
      final rawUri = url + "/Recipe/Favourites?recipeId=$id";

      final uri = Uri.parse(rawUri);

      var response = await http
          .post(
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

  Future<ApiResponseModel> removeRecipeAsFavourite(String id) async {
    try {
      final rawUri = url + "/Recipe/Favourites?recipeId=$id";

      final uri = Uri.parse(rawUri);

      var response = await http
          .delete(
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
