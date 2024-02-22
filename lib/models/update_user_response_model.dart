import 'dart:convert';

UpdateUserResponseModel updateUserResponseJson (String str) => 
  UpdateUserResponseModel.fromJson(json.decode(str));

class UpdateUserResponseModel {
  UpdateUserResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final Data? data;
  
  UpdateUserResponseModel.fromJson(Map<String, dynamic> json){
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
  Data();
  
  Data.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}