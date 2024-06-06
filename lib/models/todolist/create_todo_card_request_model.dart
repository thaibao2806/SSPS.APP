class CreateTodoCardRequestModel {
  CreateTodoCardRequestModel({
    required this.toDoNoteId,
    required this.card,
  });
  late final String? toDoNoteId;
  late final Card? card;
  
  CreateTodoCardRequestModel.fromJson(Map<String, dynamic> json){
    toDoNoteId = json['toDoNoteId'];
    card = Card.fromJson(json['card']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['toDoNoteId'] = toDoNoteId;
    _data['card'] = card!.toJson();
    return _data;
  }
}

class Card {
  Card({
    required this.title,
    required this.description,
  });
  late final String title;
  late final String description;
  
  Card.fromJson(Map<String, dynamic> json){
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