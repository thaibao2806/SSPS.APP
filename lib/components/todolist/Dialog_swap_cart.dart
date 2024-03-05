import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart'
    as ToDoCard;
import 'package:flutter/material.dart' as Material;
import 'package:ssps_app/models/todolist/get_all_todo_response_model.dart'
    as GetAll;
import 'package:ssps_app/models/todolist/update_todo_cart_request_model.dart';
import 'package:ssps_app/service/api_service.dart';

class SwapDialog extends StatefulWidget {
  final GetAll.Data toDo;
  final String? cardId;
  final String? title;
  final String? description;
  final Function() onDeleteSuccess;
  const SwapDialog({
    required this.onDeleteSuccess,
    Key? key,
    required this.cardId,
    required this.title,
    required this.description,
    required this.toDo,
  }) : super(key: key);

  @override
  _SwapDialogState createState() => _SwapDialogState();
}

class _SwapDialogState extends State<SwapDialog> {
  final title = TextEditingController();
  final description = TextEditingController();
  List<GetAll.Data> todoList = [];
  GetAll.Data? selectedTodo;
  @override
  void initState() {
    super.initState();
    setState(() {
      title.text = widget.title!; // Đảm bảo giá trị không null
      description.text = widget.description!;
      // selectedTodo?.id = widget.toDo.id ;
    });
    refreshTodoList();
    // Set initial values for start date, end date, and selected color
  }

  void refreshTodoList() {
    ApiService.getAllTodo().then((response) {
      if (response.result) {
        setState(() {
          todoList = response.data;
          for (var data in todoList) {
          print('Title: ${data.id}');
          print('From Date: ${data.title}');
          // Tiếp tục với các thuộc tính khác nếu cần
        }

        });
      }
    });
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
      title: Text('Swap card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           DropdownButtonFormField<GetAll.Data>(
            value: selectedTodo,
            items: todoList.map((todo) {
              return DropdownMenuItem(
                value: todo,
                child: Text(todo.title ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTodo = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Select todo',
            ),
          ),
          // TextField(
          //   controller: title,
          //   decoration: InputDecoration(
          //     labelText: 'Title',
          //   ),
          // ),
          // TextField(
          //   controller: description,
          //   maxLines: null,
          //   decoration: InputDecoration(
          //     labelText: 'Description',
          //   ),
          // ),
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
            if (title.text.isEmpty) {
              print(title.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter title.'),
                ),
              );
            } else {

              ApiService.swapCart(widget.cardId, widget.toDo.id, selectedTodo?.id).then((response) => {
                if(response.result) {
                  widget.onDeleteSuccess(),
                  Navigator.of(context).pop(),
                }
              });
            }
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
