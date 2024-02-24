class UpdateTodoNoteRequestModel {
  UpdateTodoNoteRequestModel({
    required this.id,
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.color,
    required this.cards,
  });
  late final String? id;
  late final String? title;
  late final String? fromDate;
  late final String? toDate;
  late final String? color;
  late final List<Cards> cards;
  
  UpdateTodoNoteRequestModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    color = json['color'];
    cards = List.from(json['cards']).map((e)=>Cards.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['fromDate'] = fromDate;
    _data['toDate'] = toDate;
    _data['color'] = color;
    _data['cards'] = cards.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Cards {
  Cards({
    required this.title,
    required this.description,
  });
  late final String? title;
  late final String? description;
  
  Cards.fromJson(Map<String, dynamic> json){
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['description'] = description;
    return _data;
  }
}