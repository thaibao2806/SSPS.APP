import 'dart:convert';

GetCategoryResponseModel getCategoryResponseJson (String str) => 
  GetCategoryResponseModel.fromJson(json.decode(str));

class GetCategoryResponseModel {
  GetCategoryResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final List<Data> data;
  
  GetCategoryResponseModel.fromJson(Map<String, dynamic> json){
    result = json['result'] ?? false;
    msgCode = json['msgCode'] as String?;
    msgDesc = json['msgDesc'] as String?;
    data = (json['data'] != null ? (json['data'] as List<dynamic>).map((e) => Data.fromJson(e as Map<String, dynamic>)).toList() : []);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.isDefault,
  });
  late final String? id;
  late final String? name;
  late final bool isDefault;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['isDefault'] = isDefault;
    return _data;
  }
}