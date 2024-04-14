  import 'dart:convert';

  ReportResponseModel reportResponseJson (String str) => 
    ReportResponseModel.fromJson(json.decode(str));

  class ReportResponseModel {
    ReportResponseModel({
      required this.result,
      required this.msgCode,
      required this.msgDesc,
      required this.data,
    });
    late final bool result;
    late final String? msgCode;
    late final String? msgDesc;
    late final Data? data;
    
    ReportResponseModel.fromJson(Map<String, dynamic> json){
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
      required this.totalExpectMoney,
      required this.totalActualMoney,
      required this.listDiagramData,
    });
    late final double totalExpectMoney;
    late final double totalActualMoney;
    late final List<ListDiagramData> listDiagramData;
    
    Data.fromJson(Map<String, dynamic> json){
      totalExpectMoney = json['totalExpectMoney'].toDouble();
      totalActualMoney = json['totalActualMoney'].toDouble();
      listDiagramData = List.from(json['listDiagramData']).map((e)=>ListDiagramData.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
      final _data = <String, dynamic>{};
      _data['totalExpectMoney'] = totalExpectMoney;
      _data['totalActualMoney'] = totalActualMoney;
      _data['listDiagramData'] = listDiagramData.map((e)=>e.toJson()).toList();
      return _data;
    }
  }

  class ListDiagramData {
    ListDiagramData({
      required this.doM,
      required this.expectMoney,
      required this.actualMoney,
    });
    late final int doM;
    late final double expectMoney;
    late final double actualMoney;
    
    ListDiagramData.fromJson(Map<String, dynamic> json){
      doM = json['doM'];
      expectMoney = json['expectMoney'].toDouble();
      actualMoney = json['actualMoney'].toDouble();
    }

    Map<String, dynamic> toJson() {
      final _data = <String, dynamic>{};
      _data['doM'] = doM;
      _data['expectMoney'] = expectMoney;
      _data['actualMoney'] = actualMoney;
      return _data;
    }
  }