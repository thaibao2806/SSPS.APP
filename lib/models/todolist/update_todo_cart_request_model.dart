class UpdateTodoCartRequestModel {
  UpdateTodoCartRequestModel({
    required this.toDoNoteId,
    required this.cardId,
    required this.title,
    required this.description,
  });
  late final String? toDoNoteId;
  late final String? cardId;
  late final String? title;
  late final String? description;
  
  UpdateTodoCartRequestModel.fromJson(Map<String, dynamic> json){
    toDoNoteId = json['toDoNoteId'];
    cardId = json['cardId'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['toDoNoteId'] = toDoNoteId;
    _data['cardId'] = cardId;
    _data['title'] = title;
    _data['description'] = description;
    return _data;
  }
}