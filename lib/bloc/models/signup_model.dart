class SignupModel {
  String? email;
  String? password;
  String? fcmToken;
  String? firstname;
  String? surname;

  SignupModel(
      {this.email, this.password, this.fcmToken, this.firstname, this.surname});

  SignupModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fcmToken = json['fcmToken'];
    firstname = json['firstname'];
    surname = json['surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['fcmToken'] = fcmToken;
    data['firstname'] = firstname;
    data['surname'] = surname;
    return data;
  }
}
