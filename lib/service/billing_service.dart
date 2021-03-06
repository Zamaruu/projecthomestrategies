import 'dart:async';
import 'dart:convert';

import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/service/household_service.dart';
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

  Future<Map<String, List>> getBillsAndCategories(
      HouseholdModel? household) async {
    if (household == null) {
      return <String, List>{
        "bills": <BillModel>[],
        "categories": <BillCategoryModel>[],
      };
    } else {
      var householdId = household.householdId!;
      var bills = await getBillsForHousehold(householdId);
      var categories = await getBillCategoriesForHousehold(householdId);
      var users =
          await HouseholdService(token).getMemberOfHousehold(householdId);

      return <String, List>{
        "bills": bills.object,
        "categories": categories.object,
        "users": users.object,
      };
    }
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
        var jsonBody = jsonDecode(response.body);

        return ApiResponseModel.success(
          response.statusCode,
          List<BillCategoryModel>.from(
            jsonBody.map((model) => BillCategoryModel.fromJson(model)),
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

  Future<ApiResponseModel> editBillingCategory(
    BillCategoryModel category,
  ) async {
    try {
      final rawUri = url + "/BillCategories/${category.billCategoryId}";

      final uri = Uri.parse(rawUri);

      var response = await http
          .put(
            uri,
            headers: header,
            body: jsonEncode(category.toJson()),
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

  Future<ApiResponseModel> deleteBillCategory(
    int categoryId,
  ) async {
    try {
      final rawUri = url + "/BillCategories/$categoryId";

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
          message: response.body,
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
    int householdId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final rawUri = url +
          "/Bills/Paged/$householdId?pageNumber=$pageNumber&pageSize=$pageSize";

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

  Future<ApiResponseModel> getBill(
    int id,
    bool includeImages,
  ) async {
    try {
      final rawUri = url + "/Bills/Single/$id?includeImages=$includeImages";

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
          BillModel.fromJson(jsonDecode(response.body)),
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

  Future<ApiResponseModel> createNewBill(
    BillModel newBill,
  ) async {
    try {
      final rawUri = url + "/Bills";

      final uri = Uri.parse(rawUri);

      var jsonBill = newBill.toCreateJson();
      var body = jsonEncode(jsonBill);

      var response = await http
          .post(
            uri,
            headers: header,
            body: body,
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          BillModel.fromJson(
            jsonDecode(
              response.body,
            ),
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

  Future<ApiResponseModel> editBill(
    BillModel bill,
  ) async {
    try {
      final rawUri = url + "/Bills/${bill.billId}";

      final uri = Uri.parse(rawUri);

      var response = await http
          .put(
            uri,
            headers: header,
            body: jsonEncode(bill.toJson()),
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          BillModel.fromJson(jsonDecode(
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

  Future<ApiResponseModel> deleteBill(
    int billId,
  ) async {
    try {
      final rawUri = url + "/Bills/$billId";

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
          message: response.body,
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

  Future<ApiResponseModel> deleteBillImages(
    List<int> images,
  ) async {
    try {
      final rawUri = url + "/Bills/Images";

      final uri = Uri.parse(rawUri);

      var response = await http
          .delete(
            uri,
            headers: header,
            body: jsonEncode(images),
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        return ApiResponseModel.success(
          response.statusCode,
          response.body,
          message: response.body,
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
