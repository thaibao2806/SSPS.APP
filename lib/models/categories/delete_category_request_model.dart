class DeleteCategoryRequestModel {
  DeleteCategoryRequestModel({
    required this.id,
  });
  late final String? id;
  
  DeleteCategoryRequestModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    return _data;
  }
}