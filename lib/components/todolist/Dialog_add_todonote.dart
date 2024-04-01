import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/todolist/create_todo_note_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_note_request_model.dart' as TodoNote;
import 'package:ssps_app/service/api_service.dart';


class CustomDialog extends StatefulWidget {
  final Function() onDeleteSuccess;

  const CustomDialog({super.key, required this.onDeleteSuccess});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Color _selectedColor;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
  final DateFormat _dateFormats = DateFormat('dd-mm-yyyy');
  
  // Biến để lưu trữ giá trị trước khi mở hộp thoại màu
  late String _savedTitle;
  late String _savedStartTime;
  late String _savedEndTime;

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
  }

  String colorToString(Color color) {
    return '${color.value.toRadixString(16)}';
  }

  final title = TextEditingController();
    final startTimeController = TextEditingController();
    final startDayController = TextEditingController();
    final endTimeController = TextEditingController();
    final endDayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    
    return AlertDialog(
      title: Text('Add column'),
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
            controller: startTimeController,
            decoration: InputDecoration(labelText: 'Start Time'),
            onTap: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDateTime != null) {
                startTimeController.text = _dateFormat.format(DateTime(pickedDateTime.year, pickedDateTime.month, pickedDateTime.day , 1, 1, 59));
              }
            },
          ),
          TextField(
            controller: endTimeController,
            decoration: InputDecoration(labelText: 'End Time'),
            onTap: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDateTime != null) {
                endTimeController.text = _dateFormat.format(DateTime(pickedDateTime.year, pickedDateTime.month, pickedDateTime.day, 23, 59, 59));
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
                  Icon(Icons.square, color: _selectedColor, size: 35,),

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
            if(title.text.isEmpty || startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter title, start time and end time.'),
                            ),
                          );
            } else {
              DateTime startDate = _dateFormat.parse(startTimeController.text);
              DateTime endDate = _dateFormat.parse(endTimeController.text);
              if(startDate.isBefore(endDate)) {
                // Thực hiện tạo mới card ở đây
                Cards newCard = Cards(title: '', description: '',);
                CreateTodoNoteRequestModel model = CreateTodoNoteRequestModel(title: title.text, fromDate: startTimeController.text.toString(), toDate: endTimeController.text.toString(), color: colorToString(_selectedColor), cards: []);
                ApiService.createTodoNote(model).then((response) => {
                  if(response.result) {
                    widget.onDeleteSuccess(),
                    Navigator.of(context).pop(),
                  }
                });
              } else {
                // Hiển thị thông báo nếu ngày bắt đầu không trước ngày kết thúc
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Start date must be before end date.'),
                  ),
                );
              }
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
