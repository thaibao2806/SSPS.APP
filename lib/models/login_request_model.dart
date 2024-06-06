class LoginRequestModel {
  LoginRequestModel({
    required this.email,
    required this.password,
<<<<<<< HEAD
  });
  late final String? email;
  late final String? password;
=======
    required this.deviceToken,
  });
  late final String? email;
  late final String? password;
  late final String? deviceToken;
>>>>>>> dev
  
  LoginRequestModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    password = json['password'];
<<<<<<< HEAD
=======
    password = json['deviceToken'];
>>>>>>> dev
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['password'] = password;
<<<<<<< HEAD
=======
    _data['deviceToken'] = deviceToken;
>>>>>>> dev
    return _data;
  }
}