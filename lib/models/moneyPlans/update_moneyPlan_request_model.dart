class UpdateMoneyPlanRequestModels {
  UpdateMoneyPlanRequestModels({
    required this.id,
    required this.status,
    required this.expectAmount,
    required this.actualAmount,
    required this.day,
    required this.month,
    required this.year,
    required this.usages,
  });
  late final String? id;
  late final String? status;
  late final double? expectAmount;
  late final double? actualAmount;
  late final int day;
  late final int month;
  late final int year;
  late final List<Usages> usages;
  
  UpdateMoneyPlanRequestModels.fromJson(Map<String, dynamic> json){
    id = json['id'];
    status = json['status'];
    expectAmount = json['expectAmount'];
    actualAmount = json['actualAmount'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
    usages = List.from(json['usages']).map((e)=>Usages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['status'] = status;
    _data['expectAmount'] = expectAmount;
    _data['actualAmount'] = actualAmount;
    _data['day'] = day;
    _data['month'] = month;
    _data['year'] = year;
    _data['usages'] = usages.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Usages {
  Usages({
    required this.name,
    required this.expectAmount,
    required this.actualAmount,
    required this.priority,
    required this.categoryId,
  });
  late final String? name;
  late final double? expectAmount;
  late final double? actualAmount;
  late final int priority;
  late final String? categoryId;
  
  Usages.fromJson(Map<String, dynamic> json){
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