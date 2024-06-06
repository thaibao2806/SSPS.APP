class CreateMoneyPlanRequestModel {
  CreateMoneyPlanRequestModel({
    required this.expectAmount,
    required this.currencyUnit,
    required this.fromDate,
    required this.toDate,
    required this.usageMoneys,
  });
  late final double? expectAmount;
  late final String? currencyUnit;
  late final String? fromDate;
  late final String? toDate;
  late final List<UsageMoneys> usageMoneys;
  
  CreateMoneyPlanRequestModel.fromJson(Map<String, dynamic> json){
    expectAmount = json['expectAmount'];
    currencyUnit = json['currencyUnit'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    usageMoneys = List.from(json['usageMoneys']).map((e)=>UsageMoneys.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['expectAmount'] = expectAmount;
    _data['currencyUnit'] = currencyUnit;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    _data['usageMoneys'] = usageMoneys.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class UsageMoneys {
  UsageMoneys({
    required this.name,
    required this.expectAmount,
    required this.priority,
    required this.categoryId,
  });
  late final String? name;
  late final double? expectAmount;
  late final int priority;
  late final String? categoryId;
  
  UsageMoneys.fromJson(Map<String, dynamic> json){
    name = json['name'];
    expectAmount = json['expectAmount'];
    priority = json['priority'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['expectAmount'] = expectAmount;
    _data['priority'] = priority;
    _data['categoryId'] = categoryId;
    return _data;
  }
}