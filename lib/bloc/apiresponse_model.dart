class ApiResponseModel {
  late String? message;
  final int statusCode;
  final dynamic object;
  late bool? hasError;

  ApiResponseModel(this.statusCode, this.message, this.object, this.hasError);

  ApiResponseModel.success(this.statusCode, this.object, {this.message}) {
    hasError = false;
  }

  ApiResponseModel.error(this.statusCode, this.message, {this.object}) {
    hasError = true;
  }

  @override
  String toString() {
    return "Statuscode: $statusCode,\nMessage: $message,\nHat Fehler: $hasError,\nObjekt: $object";
  }
}
