class SignupModel {
  String? email;
  String? password;
  String? firstname;
  String? surname;

  SignupModel({this.email, this.password, this.firstname, this.surname});

  SignupModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    firstname = json['firstname'];
    surname = json['surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['firstname'] = firstname;
    data['surname'] = surname;
    return data;
  }
}
