import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';

class HouseholdModel {
  int? householdId;
  String? householdName;
  List<UserModel>? householdMember;
  int? adminId;
  UserModel? householdCreator;

  HouseholdModel({
    this.householdId,
    this.householdName,
    this.householdMember,
    this.adminId,
  });

  HouseholdModel.fromJson(Map<String, dynamic> json) {
    householdId = json['householdId'];
    householdName = json['householdName'];
    adminId = json['adminId'];
    householdMember = json['householdMember'] != null
        ? List<UserModel>.from(
            json['householdMember'].map((model) => UserModel.fromJson(model)),
          )
        : null;
    householdCreator = json['householdCreator'] != null
        ? UserModel.fromJson(json['householdCreator'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['householdId'] = householdId;
    data['householdName'] = householdName;
    data['adminId'] = adminId;
    if (householdMember != null) {
      data['householdMember'] =
          householdMember!.map((v) => v.toJson()).toList();
    }
    if (householdCreator != null) {
      data['householdCreator'] = householdCreator!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['householdName'] = householdName;
    data['adminId'] = adminId;
    if (householdCreator != null) {
      data['householdCreator'] = householdCreator!.toJson();
    }
    return data;
  }
}
