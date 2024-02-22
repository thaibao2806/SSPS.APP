class RegisterRequestModel {
  RegisterRequestModel({
    required this.code,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.school,
    required this.location,
  });
  late final String? code;
  late final String? email;
  late final String? password;
  late final String? firstName;
  late final String? lastName;
  late final String? phone;
  late final String? role;
  late final String? school;
  late final String? location;
  
  RegisterRequestModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    email = json['email'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    role = json['role'];
    school = json['school'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['email'] = email;
    _data['password'] = password;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['phone'] = phone;
    _data['role'] = role;
    _data['school'] = school;
    _data['location'] = location;
    return _data;
  }
}