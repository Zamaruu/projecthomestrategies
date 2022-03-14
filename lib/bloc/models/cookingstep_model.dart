class CookingStepModel {
  String? id;
  int? stepNumber;
  String? title;
  String? description;

  CookingStepModel({this.id, this.stepNumber, this.title, this.description});

  CookingStepModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepNumber = json['stepNumber'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepNumber'] = stepNumber;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
