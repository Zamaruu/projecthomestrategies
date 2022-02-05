import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class BillModel {
  int? billId;
  double? amount;
  DateTime? date;
  DateTime? createdAt;
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
    date = DateTime.parse(json['date']);
    createdAt = DateTime.parse(json['createdAt']);
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
    data['date'] = date.toString();
    data['createdAt'] = createdAt.toString();
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

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['date'] = date.toString();
    data['createdAt'] = createdAt.toString();
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

  @override
  String toString() {
    return "Buyer: ${buyer!.email}\nAmount: $amount€\nDate: ${date.toString()}";
  }
}
