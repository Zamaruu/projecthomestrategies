import 'dart:async';
import 'dart:convert';

import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:http/http.dart' as http;

class BillingService {
  late String url;
  final String token;
  late Map<String, String> header;

  BillingService(this.token) {
    url = Global.baseApiUrl;
    header = Global.getHeaderWithAuthentication(token);
  }

  Future<Map<String, List>> getBillsAndCategories(int householdId) async {
    var bills = await getBillsForHousehold(householdId);
    var categories = await getBillCategoriesForHousehold(householdId);

    return <String, List>{
      "bills": bills.object,
      "categories": categories.object,
    };
  }

  //Bill Categories
  Future<ApiResponseModel> createBillingCategory(
    BillCategoryModel newCategory,
  ) async {
    try {
      final rawUri = url + "/BillCategories";

      final uri = Uri.parse(rawUri);

      var response = await http
          .post(
            uri,
            headers: header,
            body: jsonEncode(newCategory.toCreateJson()),
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          BillCategoryModel.fromJson(jsonDecode(
            response.body,
          )),
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

  Future<ApiResponseModel> getBillCategoriesForHousehold(
    int householdId,
  ) async {
    try {
      final rawUri = url + "/BillCategories/ForHousehold/$householdId";

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
          jsonDecode(response.body),
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

  //Bills
  Future<ApiResponseModel> getBillsForHousehold(
    int householdId,
  ) async {
    try {
      final rawUri = url + "/Bills/$householdId";

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
          List<BillModel>.from(
            jsonBody.map((model) => BillModel.fromJson(model)),
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