class LoginRequestModel {
  LoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceToken,
  });
  late final String? email;
  late final String? password;
  late final String? deviceToken;
  
  LoginRequestModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    password = json['password'];
    password = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['password'] = password;
    _data['deviceToken'] = deviceToken;
    return _data;
  }
}