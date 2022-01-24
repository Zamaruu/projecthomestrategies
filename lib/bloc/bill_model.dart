import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';

class BillModel {
  int? billId;
  int? amount;
  DateTime? date;
  UserModel? buyer;
  HouseholdModel? household;
  BillCategoryModel? category;

  BillModel(
      {this.billId,
      this.amount,
      this.date,
      this.buyer,
      this.household,
      this.category});

  BillModel.fromJson(Map<String, dynamic> json) {
    billId = json['billId'];
    amount = json['amount'];
    date = json['date'];
    buyer = json['buyer'] != null ? UserModel.fromJson(json['buyer']) : null;
    household = json['household'] != null
        ? HouseholdModel.fromJson(json['household'])
        : null;
    category = json['category'] != null
        ? BillCategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billId'] = billId;
    data['amount'] = amount;
    data['date'] = date;
    if (buyer != null) {
      data['buyer'] = buyer!.toJson();
    }
    if (household != null) {
      data['household'] = household!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}
