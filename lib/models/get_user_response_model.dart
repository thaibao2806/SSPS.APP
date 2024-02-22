import 'dart:convert';

GetUserResponseModel getUserResponseJson (String str) => 
  GetUserResponseModel.fromJson(json.decode(str));

class GetUserResponseModel {
  GetUserResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final Data? data;
  
  GetUserResponseModel.fromJson(Map<String, dynamic> json){
    result = json['result'];
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
    data = json['data'] !=null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.code,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.location,
    required this.status,
  });
  late final String code;
  late final String email;
  late final String phone;
  late final String firstName;
  late final String lastName;
  late final String school;
  late final String location;
  late final String status;
  
  Data.fromJson(Map<String, dynamic> json){
    code = json['code'];
    email = json['email'];
    phone = json['phone'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    school = json['school'];
    location = json['location'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['school'] = school;
    _data['location'] = location;
    _data['status'] = status;
    return _data;
  }
}