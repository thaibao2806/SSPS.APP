import 'dart:convert';

GetAllTodoResponseModel getAllTodoResponseJson (String str) => 
  GetAllTodoResponseModel.fromJson(json.decode(str));

class GetAllTodoResponseModel {
  GetAllTodoResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final List<Data> data;
  
  GetAllTodoResponseModel.fromJson(Map<String, dynamic> json){
<<<<<<< HEAD
    result = json['result'];
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
=======
    result = json['result'] ?? false;
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
    data = json['data'] != null ? List.from(json['data']).map((e) => Data.fromJson(e)).toList() : [];
>>>>>>> dev
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
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.color,
    required this.cards,
  });
  late final String? id;
  late final String? title;
  late final String? fromDate;
  late final String? toDate;
  late final String? color;
  late final List<Cards> cards;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    color = json['color'];
    cards = List.from(json['cards']).map((e)=>Cards.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    _data['color'] = color;
    _data['cards'] = cards.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Cards {
  Cards({
    required this.id,
    required this.title,
    required this.description,
  });
  late final String? id;
  late final String? title;
  late final String? description;
  
  Cards.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    return _data;
  }
}