import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class ApiResponseHandlerService {
  final BuildContext context;
  final int? statusCode;
  final String? customMessage;
  final ApiResponseModel? response;

  //Konstruktoren
  const ApiResponseHandlerService({
    this.statusCode,
    this.customMessage,
    this.response,
    required this.context,
  });

  const ApiResponseHandlerService.fromResponseModel({
    required this.context,
    required this.response,
    this.customMessage,
    this.statusCode,
  });

  const ApiResponseHandlerService.custom({
    required this.context,
    required this.customMessage,
    required this.statusCode,
    this.response,
  });

  //Methoden
  Color getColorFromStatusCode() {
    var code = response != null ? response!.statusCode : statusCode!;

    if (code >= 200 && code <= 299) {
      return Theme.of(context).primaryColor;
    } else if (code >= 300 && code <= 399) {
      return Colors.lightGreen;
    } else if (code >= 400 && code <= 499) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  void showSnackbar() {
    var text = response != null
        ? Global.removeQuotationMarksFromString(response!.message!)
        : customMessage!;
    var color = getColorFromStatusCode();

    var snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
