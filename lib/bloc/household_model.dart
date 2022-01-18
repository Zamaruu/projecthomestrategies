class HouseholdModel {
  int? householdId;
  String? householdName;
  dynamic householdMember;
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
    data['householdMember'] = householdMember;
    data['householdBills'] = householdBills;
    return data;
  }
}