import 'dart:convert';

GetMoneyPlanResponseModel getMoneyPlanJson(String str) {
  if (str?.isNotEmpty != true) {
    throw Exception('Input string is null or empty');
  }

  try {
    final Map<String, dynamic> jsonMap = json.decode(str);
    return GetMoneyPlanResponseModel.fromJson(jsonMap);
  } catch (e) {
    throw Exception('Failed to parse JSON: $e');
  }
}

class GetMoneyPlanResponseModel {
  GetMoneyPlanResponseModel({
    required this.result,
    required this.msgCode,
    required this.msgDesc,
    required this.data,
    required this.paginationResult,
  });

  late final bool result;
  late final String? msgCode;
  late final String? msgDesc;
  late final List<Data> data;
  late final PaginationResult paginationResult;

  GetMoneyPlanResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      result = json['result'] ?? false;
      msgCode = json['msgCode'];
      msgDesc = json['msgDesc'];
      data = (json['data'] as List<dynamic>?)
              ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
              ?.toList() ??
          [];
      paginationResult =
          PaginationResult.fromJson(json['paginationResult'] ?? {});
    } else {
      throw Exception('Invalid JSON data');
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['msgCode'] = msgCode;
    _data['msgDesc'] = msgDesc;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['paginationResult'] = paginationResult.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.status,
    required this.expectAmount,
    required this.actualAmount,
    required this.date,
    required this.currencyUnit,
    required this.usageMoneys,
  });

  late final String? id;
  late final String? status;
  late final double expectAmount;
  late final double actualAmount;
  late final String? date;
  late final String? currencyUnit;
  late final List<UsageMoneys> usageMoneys;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    expectAmount = json['expectAmount']?.toDouble() ?? 0.0;
    actualAmount = json['actualAmount']?.toDouble() ?? 0.0;
    date = json['date'];
    currencyUnit = json['currencyUnit'];
    usageMoneys = (json['usageMoneys'] as List<dynamic>?)
            ?.map((e) => UsageMoneys.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['status'] = status;
    _data['expectAmount'] = expectAmount;
    _data['actualAmount'] = actualAmount;
    _data['date'] = date;
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
    required this.categoryName,
    required this.priority,
  });

  late final String? name;
  late final double expectAmount;
  late final double actualAmount;
  late final String? categoryName;
  late final int priority;

  UsageMoneys.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    expectAmount = json['expectAmount']?.toDouble() ?? 0.0;
    actualAmount = json['actualAmount']?.toDouble() ?? 0.0;
    categoryName = json['categoryName'];
    priority =
        json['priority'] ?? 0; // Set a default value for priority if it is null
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['expectAmount'] = expectAmount;
    _data['actualAmount'] = actualAmount;
    _data['categoryName'] = categoryName;
    _data['priority'] = priority;
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
    page = json['page'] ?? 0; // Set a default value for page if it is null
    pageSize =
        json['pageSize'] ?? 0; // Set a default value for pageSize if it is null
    total = json['total'] ?? 0; // Set a default value for total if it is null
    totalPage = json['totalPage'] ??
        0; // Set a default value for totalPage if it is null
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
