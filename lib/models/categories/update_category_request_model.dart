class UpdateCategoryRequestModel {
  UpdateCategoryRequestModel({
    required this.categories,
  });
  late final List<Categories> categories;
  
  UpdateCategoryRequestModel.fromJson(Map<String, dynamic> json){
    categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Categories {
  Categories({
    required this.name,
    required this.isDefault,
  });
  late final String? name;
  late final bool isDefault;
  
  Categories.fromJson(Map<String, dynamic> json){
    name = json['name'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['isDefault'] = isDefault;
    return _data;
  }
}