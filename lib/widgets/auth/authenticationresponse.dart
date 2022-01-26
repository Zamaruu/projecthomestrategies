import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';

class AuthenticationResponse {
  late BuildContext context;
  late int? statusCode;
  late ApiResponseModel? responseModel;

  AuthenticationResponse.empty();

  AuthenticationResponse(this.context, this.statusCode);

  AuthenticationResponse.response(this.context, this.responseModel);

  void showSnackbar() {
    var color = getSnackbarColorFromStatusCode();
    var response = getSnackbarResponseTextFromStatusCode();

    var snackBar = SnackBar(
      backgroundColor: color,
      content: Text(response),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Color getSnackbarColorFromStatusCode() {
    int code;
    if (responseModel != null) {
      code = responseModel!.statusCode;
    } else {
      code = statusCode!;
    }

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

  String getSnackbarResponseTextFromStatusCode() {
    int code;
    if (responseModel != null) {
      return responseModel!.message!;
    } else {
      code = statusCode!;
    }

    switch (code) {
      case 200:
        return "Login war erfolgreich";
      case 201:
        return "Konto erfolgreich erstellt";
      case 307:
        return "Anfrage temporär umgeleitet aber erfolgreich";
      case 400:
        return "Anfrage ungültig!";
      case 401:
        return "Die übergebenen Anmeldedaten sind ungültig";
      case 402:
        return "";
      case 403:
        return "";
      case 409:
        return "Es existiert bereits ein Benutzer mit dieser E-Mail!";
      case 503:
        return "Der Server ist momentan unerreichbar! Probiere es später erneut.";
      case 600:
        return "Anmeldedaten nicht korrekt ausgefüllt!";
      case 601:
        return "Email nicht im korrekten Format!";
      default:
        return "Unbekannter Fehler";
    }
  }
}
