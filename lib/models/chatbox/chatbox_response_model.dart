import 'dart:convert';

ChatboxResponseModel chatboxResponseModelJson(String str) =>
    ChatboxResponseModel.fromJson(json.decode(str));

class ChatboxResponseModel {
  ChatboxResponseModel({
    required this.data,
    required this.msgCode,
    required this.msgDesc,
    required this.result,
  });
  late final Data? data;
  late final String? msgCode;
  late final String? msgDesc;
  late final bool result;

  ChatboxResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data!.toJson();
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    _data['result'] = result;
    return _data;
  }
}

class Data {
  Data({
    required this.type,
    required this.response,
  });
  late final String? type;
  late final String? response;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      response: json['response'] is int || json['response'] is double
          ? json['response'].toString()
          : json['response'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['response'] = response;
    return _data;
  }
}
