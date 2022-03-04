import 'dart:convert';
import 'dart:typed_data';

import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class BillImageModel {
  int? billImageId;
  Uint8List? image;
  BillModel? bill;

  BillImageModel({this.billImageId, this.image, this.bill});

  BillImageModel.fromJson(Map<String, dynamic> json) {
    billImageId = json['billImageId'];
    bill = json['bill'] != null ? BillModel.fromJson(json['bill']) : null;
    image = Global.isStringNullOrEmpty(json['image'])
        ? null
        : base64Decode(json['image']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billImageId'] = billImageId;
    data['image'] = image;
    data['bill'] = bill != null ? bill!.toJson() : null;
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }
}
