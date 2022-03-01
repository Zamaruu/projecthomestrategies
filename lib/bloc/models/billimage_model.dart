import 'dart:convert';
import 'dart:typed_data';

import 'package:projecthomestrategies/utils/globals.dart';

class BillImageModel {
  int? billImageId;
  Uint8List? image;

  BillImageModel({this.billImageId, this.image});

  BillImageModel.fromJson(Map<String, dynamic> json) {
    billImageId = json['billImageId'];
    image = Global.isStringNullOrEmpty(json['image'])
        ? base64Decode(json['image'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billImageId'] = billImageId;
    data['image'] = image;
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }
}
