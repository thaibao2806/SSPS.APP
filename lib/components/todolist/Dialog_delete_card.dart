import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/service/api_service.dart';


class DeleteCardDialog extends StatefulWidget {
  final String? todoId;
  final String? cardId;
  final Function() onDeleteSuccess;

  const DeleteCardDialog({
    required this.todoId,
    required this.cardId,
    required this.onDeleteSuccess,
    Key? key,
  }) : super(key: key);

  @override
  _DeleteCardDialogState createState() => _DeleteCardDialogState();
}


class _DeleteCardDialogState extends State<DeleteCardDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Do you want to delete card?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
            ApiService.deleteTodoCard(widget.todoId, widget.cardId).then((response) => {
              if(response.result) {
                widget.onDeleteSuccess(),
                Navigator.of(context).pop(),
              }
            });
          },
          child: Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
