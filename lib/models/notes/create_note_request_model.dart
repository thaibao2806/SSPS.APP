class CreateNoteRequestModel {
  CreateNoteRequestModel({
    required this.title,
    required this.description,
    required this.color,
    required this.fromDate,
    required this.toDate,
  });
  late final String? title;
  late final String? description;
  late final String? color;
  late final String? fromDate;
  late final String? toDate;
  
  CreateNoteRequestModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    description = json['description'];
    color = json['color'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['description'] = description;
    _data['color'] = color;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    return _data;
  }
}