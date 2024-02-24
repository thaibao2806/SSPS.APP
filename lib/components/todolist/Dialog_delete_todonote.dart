import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';


class DeleteColumnDialog extends StatefulWidget {
  @override
  _DeleteColumnDialogState createState() => _DeleteColumnDialogState();
}

class _DeleteColumnDialogState extends State<DeleteColumnDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Color _selectedColor;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    // Set initial values for start date, end date, and selected color
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _selectedColor = Colors.blue; // Set your initial color here
  }

  @override
  Widget build(BuildContext context) {
    final eventNameController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    return AlertDialog(
      title: Text('Do you want to delete column?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // TextField(
          //   decoration: InputDecoration(
          //     labelText: 'Title',
          //   ),
          // ),
          // TextField(
          //   decoration: InputDecoration(
          //     labelText: 'Description',
          //   ),
          // ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement your logic here for saving data or any other action.
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
