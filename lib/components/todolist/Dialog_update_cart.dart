import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart' as ToDoCard;
import 'package:flutter/material.dart' as Material;
import 'package:ssps_app/models/todolist/update_todo_cart_request_model.dart';
import 'package:ssps_app/service/api_service.dart';


class UpdateCardDialog extends StatefulWidget {

  final String? toDoNoteId;
  final String? cardId;
  final String? title;
  final String? description;
  final Function() onDeleteSuccess;
  const UpdateCardDialog({ required this.toDoNoteId, required this.onDeleteSuccess, Key? key,required this.cardId,required this.title,required this.description,}): super(key: key);

  @override
  _UpdateCardDialogState createState() => _UpdateCardDialogState();
}

class _UpdateCardDialogState extends State<UpdateCardDialog> {

  final title = TextEditingController();
  final description = TextEditingController();
  @override
  void initState() {
    super.initState();
   setState(() {
      title.text = widget.title! ; // Đảm bảo giá trị không null
      description.text = widget.description!;
   });
    // Set initial values for start date, end date, and selected color
  }

   @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTitleEmpty = false;
    bool isDescriptionEmpty = false;
    bool isError = false;
    return AlertDialog(
      title: Text('Edit card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: title,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: description,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red[400],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue[300],
          ),
          onPressed: () {
            if(title.text.isEmpty ) {
              print(title.text);
              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter title.'),
                            ),
                          );
            } else {
              print(title.text);
              // print('isTitleEmpty: ${title.text.isEmpty}');
              UpdateTodoCartRequestModel model = UpdateTodoCartRequestModel(toDoNoteId: widget.toDoNoteId, cardId: widget.cardId, title: title.text, description: description.text);
               ApiService.updateTodoCard(model).then((response) => {
                if(response.result) {
                  widget.onDeleteSuccess(),
                  Navigator.of(context).pop(),
                }
              });
            }
            
          },
          child: Text('Save', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
