import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart' as ToDoCard;
import 'package:flutter/material.dart' as Material;
import 'package:ssps_app/service/api_service.dart';


class AddCardDialog extends StatefulWidget {

  final String? toDoNoteId;
  final Function() onDeleteSuccess;
  const AddCardDialog({ required this.toDoNoteId, required this.onDeleteSuccess, Key? key,}): super(key: key);

  @override
  _AddCardDialogState createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {

  @override
  void initState() {
    super.initState();
    // Set initial values for start date, end date, and selected color
  }

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final description = TextEditingController();
    bool isTitleEmpty = false;
    bool isDescriptionEmpty = false;
    bool isError = false;
    return AlertDialog(
      title: Text('Add card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: title,
            // onChanged: (value) {
            //   setState(() {
            //     isTitleEmpty = value.isEmpty;
            //   });
            // },
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: description,
            maxLines: null,
            // onChanged: (value) {
            //   setState(() {
            //     isDescriptionEmpty = value.isEmpty;
            //   });
            // },
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
              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter title.'),
                            ),
                          );
            } else {
              ToDoCard.Card newCard = ToDoCard.Card(
                            title: title.text,
                            description: description.text,
                          );
                          CreateTodoCardRequestModel model = CreateTodoCardRequestModel(toDoNoteId: widget.toDoNoteId, card: newCard);
                          ApiService.createTodoCard(model).then((response) => {
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
