import 'dart:convert';

ChangePasswordResponseModel changePasswordResponseJson (String str) => 
  ChangePasswordResponseModel.fromJson(json.decode(str));

class ChangePasswordResponseModel {
  ChangePasswordResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  
  ChangePasswordResponseModel.fromJson(Map<String, dynamic> json){
    result = json['result'];
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    return _data;
  }
}