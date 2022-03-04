import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class BillModel {
  int? billId;
  double? amount;
  String? description;
  DateTime? date;
  DateTime? createdAt;
  UserModel? buyer;
  HouseholdModel? household;
  BillCategoryModel? category;
  List<BillImageModel>? images;

  BillModel({
    this.billId,
    this.amount,
    this.date,
    this.description,
    this.buyer,
    this.images,
    this.createdAt,
    this.household,
    this.category,
  });

  BillModel.fromJson(Map<String, dynamic> json) {
    billId = json['billId'];
    amount = json['amount'];
    description = json['description'];
    date = DateTime.parse(json['date']);
    createdAt = DateTime.parse(json['createdAt']);
    buyer = json['buyer'] != null ? UserModel.fromJson(json['buyer']) : null;
    household = json['household'] != null
        ? HouseholdModel.fromJson(json['household'])
        : null;
    category = json['category'] != null
        ? BillCategoryModel.fromJson(json['category'])
        : null;
    images = json['images'] != null
        ? List<BillImageModel>.from(
            json['images'].map((model) => BillImageModel.fromJson(model)),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billId'] = billId;
    data['amount'] = amount;
    data['description'] = description;
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
    if (images != null) {
      data['images'] = List.generate(
        images!.length,
        (index) => images![index].toJson(),
      );
    }
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['description'] = description;
    data['date'] = date.toString();
    if (buyer != null) {
      data['buyer'] = buyer!.toJson();
    }
    if (household != null) {
      data['household'] = household!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (images != null) {
      data['images'] = List.generate(
        images!.length,
        (index) => images![index].toJson(),
      );
    }
    return data;
  }

  @override
  String toString() {
    return "Buyer: ${buyer!.email}\nAmount: $amount€\nDate: ${date.toString()}";
  }
}
