import 'package:flutter/material.dart';

class AuthenticationResponse {
  late BuildContext context;
  late int statusCode;

  AuthenticationResponse.empty();

  AuthenticationResponse(this.context, this.statusCode);

  void showSnackbar() {
    var color = getSnackbarColorFromStatusCode(statusCode);
    var response = getSnackbarResponseTextFromStatusCode(statusCode);

    var snackBar = SnackBar(
      backgroundColor: color,
      content: Text(response),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Color getSnackbarColorFromStatusCode(int code) {
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

  String getSnackbarResponseTextFromStatusCode(int statusCode) {
    switch (statusCode) {
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
