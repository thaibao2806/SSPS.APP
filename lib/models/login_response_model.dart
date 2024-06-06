import 'dart:convert';

LoginResponseModel loginResponseJson (String str) => 
  LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final Data? data;
  
  LoginResponseModel.fromJson(Map<String, dynamic> json){
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
<<<<<<< HEAD
    _data['data'] = data!.toJson();
=======
    _data['data'] = data != null ? data!.toJson() : null;
>>>>>>> dev
    return _data;
  }
}

class Data {
  Data({
    required this.accessToken,
    required this.refreshToken,
  });
  late final String accessToken;
  late final String refreshToken;
  
  Data.fromJson(Map<String, dynamic> json){
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['accessToken'] = accessToken;
    _data['refreshToken'] = refreshToken;
    return _data;
  }
}