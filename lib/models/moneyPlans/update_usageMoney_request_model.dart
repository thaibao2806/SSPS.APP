class UpdateMoneyPlanRequestModel {
  UpdateMoneyPlanRequestModel({
    required this.moneyPlanId,
    required this.data,
  });
  late final String? moneyPlanId;
  late final List<Data> data;
  
  UpdateMoneyPlanRequestModel.fromJson(Map<String, dynamic> json){
    moneyPlanId = json['moneyPlanId'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['moneyPlanId'] = moneyPlanId;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.name,
    required this.expectAmount,
    required this.actualAmount,
    required this.priority,
    required this.categoryId,
  });
  late final String? name;
  late final double expectAmount;
  late final double actualAmount;
  late final int priority;
  late final String? categoryId;
  
  Data.fromJson(Map<String, dynamic> json){
    name = json['name'];
    expectAmount = json['expectAmount'];
    actualAmount = json['actualAmount'];
    priority = json['priority'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['expectAmount'] = expectAmount;
    _data['actualAmount'] = actualAmount;
    _data['priority'] = priority;
    _data['categoryId'] = categoryId;
    return _data;
  }
}