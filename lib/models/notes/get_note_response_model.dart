import 'dart:convert';

GetNoteResponseModel getNoteResponseJson(String str) =>
    GetNoteResponseModel.fromJson(json.decode(str));

class GetNoteResponseModel {
  GetNoteResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final List<Data> data;

  GetNoteResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] ?? false;
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
    data = (json['data'] as List<dynamic>?)
            ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.title,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.color,
  });
  late final String? id;
  late final String? title;
  late final String? description;
  late final String? fromDate;
  late final String? toDate;
  late final String? color;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    _data['color'] = color;
    return _data;
  }
}
