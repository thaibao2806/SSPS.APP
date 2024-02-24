import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';


class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
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
      title: Text('Add column'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
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
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDateTime != null) {
                // Tạo một chuỗi định dạng ngày từ DateTime đã chọn và gán vào controller
                startTimeController.text = _dateFormat.format(pickedDateTime);
              }
            },
          ),
          // SizedBox(height: 8),
          TextField(
            controller: endTimeController,
            decoration: InputDecoration(labelText: 'End Time'),
            onTap: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDateTime != null) {
                // Tạo một chuỗi định dạng ngày từ DateTime đã chọn và gán vào controller
                endTimeController.text = _dateFormat.format(pickedDateTime);
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
                color: _selectedColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'Pick Color',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
          child: Text('Save'),
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
