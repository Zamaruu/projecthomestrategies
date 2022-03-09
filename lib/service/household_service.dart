import 'dart:async';
import 'dart:convert';

import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:http/http.dart' as http;

class HouseholdService {
  late String url;
  final String token;
  late Map<String, String> header;

  HouseholdService(this.token) {
    url = Global.baseApiUrl;
    header = Global.getHeaderWithAuthentication(token);
  }

  Future<ApiResponseModel> getUserToAddToHousehold(String email) async {
    try {
      final rawUri = url + "/User/ForHousehold/$email";

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

  Future<ApiResponseModel> createNewHousehold(HouseholdModel household) async {
    try {
      final rawUri = url + "/Household";

      final uri = Uri.parse(rawUri);

      var response = await http
          .post(
            uri,
            headers: header,
            body: jsonEncode(household.toCreateJson()),
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          HouseholdModel.fromJson(jsonDecode(response.body)),
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

  Future<ApiResponseModel> addUserToHousehold(
    UserModel user,
    int householdId,
  ) async {
    try {
      final rawUri = url +
          "/Household/AddUser/?email=${user.email}&householdId=$householdId";

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

  Future<ApiResponseModel> removeUserFromHousehold(
    UserModel user,
    int householdId,
  ) async {
    try {
      final rawUri = url +
          "/Household/RemoveUser/?userId=${user.userId}&householdId=$householdId";

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
          "",
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

  Future<ApiResponseModel> getMemberOfHousehold(
    int householdId,
  ) async {
    try {
      final rawUri = url + "/Household/Members/$householdId";

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
          List<UserModel>.from(
            jsonBody.map((model) => UserModel.fromJson(model)),
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

  Future<ApiResponseModel> getHouseholdForManagement(
    int householdId,
  ) async {
    try {
      final rawUri = url + "/Household/Management/$householdId";

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
          HouseholdModel.fromJson(jsonDecode(response.body)),
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
