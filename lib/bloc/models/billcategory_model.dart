import 'package:projecthomestrategies/bloc/models/household_model.dart';

class BillCategoryModel {
  int? billCategoryId;
  String? billCategoryName;
  DateTime? createdAt;
  HouseholdModel? household;

  BillCategoryModel(
      {this.billCategoryId, this.billCategoryName, this.household});

  BillCategoryModel.fromJson(Map<String, dynamic> json) {
    billCategoryId = json['billCategoryId'];
    billCategoryName = json['billCategoryName'];
    createdAt = DateTime.tryParse(json['createdAt']);
    household = json['household'] != null
        ? HouseholdModel.fromJson(json['household'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billCategoryId'] = billCategoryId;
    data['billCategoryName'] = billCategoryName;
    data['createdAt'] = createdAt != null ? createdAt.toString() : "";
    if (household != null) {
      data['household'] = household!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billCategoryName'] = billCategoryName;
    if (household != null) {
      data['household'] = household!.toJson();
    }
    return data;
  }
}
