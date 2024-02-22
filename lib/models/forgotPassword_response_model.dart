import 'dart:convert';

ForgotPasswordResponseModel forgotPasswordResponseJson (String str) => 
  ForgotPasswordResponseModel.fromJson(json.decode(str));

class ForgotPasswordResponseModel {
  ForgotPasswordResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  
  ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json){
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