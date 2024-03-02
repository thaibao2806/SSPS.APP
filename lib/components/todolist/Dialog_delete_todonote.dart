import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/pages/todolistPage.dart';
import 'package:ssps_app/service/api_service.dart';


class DeleteColumnDialog extends StatefulWidget {
  final String? todoId;
  final Function() onDeleteSuccess;

  const DeleteColumnDialog({
    required this.todoId,
    required this.onDeleteSuccess,
    Key? key,
  }) : super(key: key);

  @override
  _DeleteColumnDialogState createState() => _DeleteColumnDialogState();
}


class _DeleteColumnDialogState extends State<DeleteColumnDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Do you want to delete column?'),
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
            ApiService.deleteTodoNote(widget.todoId).then((response) => {
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
