import 'package:projecthomestrategies/bloc/user_model.dart';

class HouseholdModel {
  int? householdId;
  String? householdName;
  List<UserModel>? householdMember;
  dynamic householdBills;

  HouseholdModel(
      {this.householdId,
      this.householdName,
      this.householdMember,
      this.householdBills});

  HouseholdModel.fromJson(Map<String, dynamic> json) {
    householdId = json['householdId'];
    householdName = json['householdName'];
    householdMember = json['householdMember'];
    householdBills = json['householdBills'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['householdId'] = householdId;
    data['householdName'] = householdName;
    if (householdMember != null) {
      data['householdMember'] =
          householdMember!.map((v) => v.toJson()).toList();
    }
    if (householdBills != null) {
      data['householdBills'] = householdBills!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['householdName'] = householdName;
    return data;
  }
}
