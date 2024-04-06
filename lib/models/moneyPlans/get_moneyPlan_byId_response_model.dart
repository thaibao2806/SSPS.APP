import 'dart:convert';

GetMoneyPlanByIdResponseModel getMoneyPlanIdResponseModelJson (String str) => 
  GetMoneyPlanByIdResponseModel.fromJson(json.decode(str));


class GetMoneyPlanByIdResponseModel {
  GetMoneyPlanByIdResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
    required this.paginationResult,
  });
  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final Data? data;
  late final PaginationResult? paginationResult;

  GetMoneyPlanByIdResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] ?? false;
    msgCode = json['msgCode'] ?? "" ;
    msgDesc = json['msgDesc'] ?? "";
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    paginationResult =json['paginationResult'] != null ? PaginationResult.fromJson(json['paginationResult']) : null;
  }
  

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    _data['data'] = data!.toJson();
    _data['paginationResult'] = paginationResult!.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.status,
    required this.expectAmount,
    required this.actualAmount,
    required this.currencyUnit,
    required this.usageMoneys,
  });
  late final String? id;
  late final String? status;
  late final int expectAmount;
  late final int actualAmount;
  late final String? currencyUnit;
  late final List<UsageMoneys> usageMoneys;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    expectAmount = json['expectAmount'];
    actualAmount = json['actualAmount'];
    currencyUnit = json['currencyUnit'];
    usageMoneys = (json['usageMoneys'] as List<dynamic>?)
    ?.map((e) => UsageMoneys.fromJson(e))
    .toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['status'] = status;
    _data['expectAmount'] = expectAmount;
    _data['actualAmount'] = actualAmount;
    _data['currencyUnit'] = currencyUnit;
    _data['usageMoneys'] = usageMoneys.map((e) => e.toJson()).toList();
    return _data;
  }
}

class UsageMoneys {
  UsageMoneys({
    required this.name,
    required this.expectAmount,
    required this.actualAmount,
    required this.priority,
    required this.categoryName,
  });
  late final String? name;
  late final int expectAmount;
  late final int actualAmount;
  late final int priority;
  late final String? categoryName;

  UsageMoneys.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    expectAmount = json['expectAmount'];
    actualAmount = json['actualAmount'];
    priority = json['priority'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['expectAmount'] = expectAmount;
    _data['actualAmount'] = actualAmount;
    _data['priority'] = priority;
    _data['categoryName'] = categoryName;
    return _data;
  }
}

class PaginationResult {
  PaginationResult({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPage,
  });
  late final int page;
  late final int pageSize;
  late final int total;
  late final int totalPage;

  PaginationResult.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['pageSize'];
    total = json['total'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['page'] = page;
    _data['pageSize'] = pageSize;
    _data['total'] = total;
    _data['totalPage'] = totalPage;
    return _data;
  }
}
