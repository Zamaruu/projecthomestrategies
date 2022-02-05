import 'dart:async';
import 'dart:convert';

import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/notifcationmodel.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final String token;
  late String url;
  late Map<String, String> header;

  NotificationService(this.token) {
    url = Global.baseApiUrl;
    header = Global.getHeaderWithAuthentication(token);
  }

  Future<ApiResponseModel> getAllNotifcations() async {
    try {
      final rawUri = url + "/Notifications";

      final uri = Uri.parse(rawUri);

      var response = await http
          .get(
            uri,
            headers: header,
          )
          .timeout(Global.timeoutDuration);

      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        return ApiResponseModel.success(response.statusCode, <String, List>{
          "OpenNotifications": List<NotificationModel>.from(
              jsonBody["OpenNotfications"]
                  .map((model) => NotificationModel.fromJson(model))),
          "SeenNotifications": List<NotificationModel>.from(
              jsonBody["SeenNotifications"]
                  .map((model) => NotificationModel.fromJson(model))),
        });
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

  Future<ApiResponseModel> getUnseenNotifcations() async {
    try {
      final rawUri = url + "/Notifications/Open";

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
          List<NotificationModel>.from(
            jsonBody.map((model) => NotificationModel.fromJson(model)),
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

  Future<ApiResponseModel> setNotificationOnseen(int notificationId) async {
    try {
      final rawUri = url + "/Notifications/SetSeen/$notificationId";

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

  Future<ApiResponseModel> setNotificationsOnseen(
      List<int> notificationIds) async {
    try {
      final rawUri = url + "/Notifications/SetAllSeen";

      final uri = Uri.parse(rawUri);

      var response = await http
          .put(
            uri,
            headers: header,
            body: jsonEncode(notificationIds),
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
