<<<<<<< HEAD
=======
import 'dart:convert';

DeleteTodoNoteResponseModel deleteTodoNoteResponseJson (String str) => 
  DeleteTodoNoteResponseModel.fromJson(json.decode(str));

>>>>>>> dev
class DeleteTodoNoteResponseModel {
  DeleteTodoNoteResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
  });
  late final bool result;
  late final String? msgCode;
<<<<<<< HEAD
  late final String msgDesc;
  late final Data data;
=======
  late final String? msgDesc;
  late final Data? data;
>>>>>>> dev
  
  DeleteTodoNoteResponseModel.fromJson(Map<String, dynamic> json){
    result = json['result'];
    msgCode = json['msgCode'];
    msgDesc = json['msgDesc'];
<<<<<<< HEAD
    data = Data.fromJson(json['data']);
=======
    data = json['data'] !=null ? Data.fromJson(json['data']) : null;
>>>>>>> dev
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
<<<<<<< HEAD
    _data['data'] = data.toJson();
=======
    _data['data'] = data!.toJson();
>>>>>>> dev
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