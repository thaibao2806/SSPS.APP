import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/notes/create_note_request_model.dart';
import 'package:ssps_app/models/notes/update_note_request_model.dart';
import 'package:ssps_app/service/api_service.dart';

class DraggableSheetUpdate extends StatefulWidget {
  final Function getNote;
  final String? enventId;
  final String? enventName;
  final DateTime startTime;
  final DateTime endTime;
  final Color eventColor;
  final String? notes;
  const DraggableSheetUpdate(
      {super.key,
      required this.getNote,
      required this.enventId,
      required this.startTime,
      required this.endTime,
      required this.eventColor,
      required this.notes,
      required this.enventName});

  @override
  State<DraggableSheetUpdate> createState() => _DraggableSheetUpdateState();
}

class _DraggableSheetUpdateState extends State<DraggableSheetUpdate> {
  final title = TextEditingController();
  final description = TextEditingController();
  DateTime? _selectedFromDateTime;
  DateTime? _selectedToDateTime;
  Color _selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.notes);
      title.text = widget.enventName!;
      _selectedFromDateTime = widget.startTime;
      _selectedToDateTime = widget.endTime;
      _selectedColor = widget.eventColor;
      description.text = widget.notes!;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          if (isFrom) {
            _selectedFromDateTime = DateTime(
              picked.year,
              picked.month,
              picked.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          } else {
            _selectedToDateTime = DateTime(
              picked.year,
              picked.month,
              picked.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          }
        });
      }
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              // Use TextButton instead of FlatButton
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(builder: (context, constraints) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: title,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'From',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            controller: TextEditingController(
                              text: _selectedFromDateTime != null
                                  ? _selectedFromDateTime.toString()
                                  : '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'To',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            controller: TextEditingController(
                              text: _selectedToDateTime != null
                                  ? _selectedToDateTime.toString()
                                  : '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: description,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => _openColorPicker(),
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Choose Color',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            controller: TextEditingController(
                              // Hiển thị màu đã chọn
                              text: _selectedColor.toString(),
                              // style: TextStyle(
                              //   color: _selectedColor,
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[300],
                ),
                onPressed: () {
                  if (title.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter title.'),
                      ),
                    );
                  } else {
                    Color originalColor = _selectedColor;
                    String colorCode =
                        originalColor.value.toRadixString(16).substring(2);
                    DateTime fromDate =
                        DateTime.parse(_selectedFromDateTime.toString());
                    String formattedFromDateTime =
                        DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(fromDate);
                    DateTime toDate =
                        DateTime.parse(_selectedToDateTime.toString());
                    String formattedToDateTime =
                        DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(toDate);
                    UpdateNoteRequestModel model = UpdateNoteRequestModel(
                        id: widget.enventId,
                        title: title.text,
                        description: description.text,
                        color: colorCode,
                        fromDate: formattedFromDateTime,
                        toDate: formattedToDateTime);
                    ApiService.updateNote(model).then((response) => {
                          if (response.result)
                            {
                              print(response.result),
                              widget.getNote(),
                              Navigator.of(context).pop(),
                            }
                        });
                  }
                  ;
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300],
                ),
                onPressed: () {
                  ApiService.deleteNote(widget.enventId).then((response) => {
                        if (response.result)
                          {
                            print(response.result),
                            widget.getNote(),
                            Navigator.of(context).pop(),
                          }
                      });
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
