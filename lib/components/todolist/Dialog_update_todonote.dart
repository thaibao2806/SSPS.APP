import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/todolist/create_todo_note_request_model.dart'
    as TodoNote;
import 'package:ssps_app/models/todolist/get_all_todo_response_model.dart'
    as GetAll;
import 'package:ssps_app/models/todolist/update_todo_note_request_model.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:ssps_app/models/todolist/update_todo_note_request_model.dart'
    as UpdateModel;

class UpdateDialog extends StatefulWidget {
  final Function() onDeleteSuccess;
  final GetAll.Data todo;
  // final String? id;
  // final String? title;
  // late DateTime fromDate;
  // late DateTime toDate;
  // final String? color;

  const UpdateDialog(
      {super.key, required this.onDeleteSuccess, required this.todo});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Color _selectedColor;
  DateFormat _dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
  final DateFormat _dateFormats = DateFormat('dd, MMM, yyyy');

  // Biến để lưu trữ giá trị trước khi mở hộp thoại màu
  late String _savedTitle;
  late String _savedStartTime;
  late String _savedEndTime;

  final title = TextEditingController();
  final startTimeController = TextEditingController();
  final startDayController = TextEditingController();
  final endTimeController = TextEditingController();
  final endDayController = TextEditingController();
  final StartController = TextEditingController();
  final EndController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for start date, end date, and selected color
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _selectedColor = Colors.blue;
    // Initialize saved values
    _savedTitle = '';
    _savedStartTime = '';
    _savedEndTime = '';

    setState(() {
      title.text = widget.todo.title!;
      startTimeController.text =
          _dateFormat.format(DateTime.parse(widget.todo.fromDate!));
      endTimeController.text =
          _dateFormat.format(DateTime.parse(widget.todo.toDate!));
      EndController.text = _dateFormats.format(DateTime.parse(widget.todo.toDate!));
      StartController.text = _dateFormats.format(DateTime.parse(widget.todo.fromDate!));
      _selectedColor = widget.todo.color != null
          ? Color(int.parse('0xFF${widget.todo.color}'))
          : Colors.blue;
    });
  }


  String colorToString(Color color) {
    return '${color.value.toRadixString(16)}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit column'),
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
            controller: StartController,
            decoration: InputDecoration(labelText: 'Start Time'),
            onTap: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDateTime != null) {
                StartController.text = _dateFormats.format(DateTime(
                    pickedDateTime.year,
                    pickedDateTime.month,
                    pickedDateTime.day + 1,
                    1,
                    1,
                    59));
                startTimeController.text = _dateFormat.format(DateTime(
                    pickedDateTime.year,
                    pickedDateTime.month,
                    pickedDateTime.day + 1,
                    1,
                    1,
                    59));
                
              }
            },
          ),
          TextField(
            controller: EndController,
            decoration: InputDecoration(labelText: 'End Time'),
            onTap: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDateTime != null) {
                EndController.text = _dateFormats.format(DateTime(
                    pickedDateTime.year,
                    pickedDateTime.month,
                    pickedDateTime.day,
                    23,
                    59,
                    59));
                endTimeController.text = _dateFormat.format(DateTime(
                    pickedDateTime.year,
                    pickedDateTime.month,
                    pickedDateTime.day,
                    23,
                    59,
                    59));

              }
            },
          ),
          SizedBox(height: 15),
          // Color picker
          GestureDetector(
            onTap: () {
              _showColorPickerDialog(context);
            },
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.square,
                    color: _selectedColor,
                    size: 35,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Center(
                      child: Text(
                        'Pick Color',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
            if (title.text.isEmpty ||
                startTimeController.text.isEmpty ||
                endTimeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter title, start time and end time.'),
                ),
              );
            } else {
              List<UpdateModel.Cards> updatedCards = widget.todo.cards
                  .map((card) => UpdateModel.Cards(
                        title: card.title,
                        description: card.description,
                      ))
                  .toList();
              String startDate =
                  _dateFormat.format(DateTime.parse(startTimeController.text));
              String endDate =
                  _dateFormat.format(DateTime.parse(endTimeController.text));
              // print(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.parse(startTimeController.text!)));
              print(startDate);
              UpdateTodoNoteRequestModel model = UpdateTodoNoteRequestModel(
                  id: widget.todo.id,
                  title: title.text,
                  fromDate: startDate.toString(),
                  toDate: endDate.toString(),
                  color: colorToString(_selectedColor),
                  cards: updatedCards);
              ApiService.updateTodoNote(model).then((response) => {
                    if (response.result)
                      {
                        widget.onDeleteSuccess(),
                        Navigator.of(context).pop(),
                      }
                  });
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: BorderRadius.circular(5.0),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Lưu trữ lại các giá trị khi chọn màu và đóng hộp thoại
                _savedTitle = title.text;
                _savedStartTime = startTimeController.text;
                _savedEndTime = endTimeController.text;
                Navigator.of(context).pop();
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }
}
