import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/service/api_service.dart';

class DeleteMoneyPlanDialog extends StatefulWidget {
  final Function() onDeleteSuccess;

  const DeleteMoneyPlanDialog({
    required this.onDeleteSuccess,
    Key? key,
  }) : super(key: key);

  @override
  _DeleteMoneyPlanDialogState createState() => _DeleteMoneyPlanDialogState();
}

class _DeleteMoneyPlanDialogState extends State<DeleteMoneyPlanDialog> {
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
        children: <Widget>[],
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
            
          },
          child: Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
