import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/notes/create_note_request_model.dart';
import 'package:ssps_app/service/api_service.dart';

class DraggableSheet extends StatefulWidget {
  final Function getNote;
  final DateTime startTime;
  final DateTime endTime;
  const DraggableSheet({super.key, required this.getNote, required this.startTime, required this.endTime});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final title = TextEditingController();
  final description = TextEditingController();
  DateTime? _selectedFromDateTime;
  DateTime? _selectedToDateTime;
  Color _selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _selectedFromDateTime = widget.startTime;
    _selectedToDateTime = widget.endTime;
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
                                  // fontWeight: FontWeight.bold,
                                  // color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                            ),
                            controller: TextEditingController(
                              text: _selectedFromDateTime != null
                                  ? DateFormat('dd MMM yyyy, HH:mm')
                                      .format(_selectedFromDateTime!)
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
                                  // fontWeight: FontWeight.bold,
                                  // color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                            ),
                            controller: TextEditingController(
                              text: _selectedToDateTime != null
                                  ? DateFormat('dd MMM yyyy, HH:mm')
                                      .format(_selectedToDateTime!)
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(right: 8.0),
                  //     child: GestureDetector(
                  //       onTap: () => _openColorPicker(),
                  //       child: AbsorbPointer(
                  //         child: TextField(
                  //           decoration: InputDecoration(
                  //             labelText: 'Choose Color',
                  //             labelStyle: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               color: Color.fromARGB(255, 0, 0, 0),
                  //             ),
                  //           ),
                  //           controller: TextEditingController(
                  //             // Hiển thị màu đã chọn
                  //             text: _selectedColor.toString(),
                  //             // style: TextStyle(
                  //             //   color: _selectedColor,
                  //             // ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _openColorPicker();
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue[300],
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 20)),
                onPressed: () {
                  if (title.text.isEmpty ||
                      _selectedFromDateTime == null ||
                      _selectedToDateTime == null || _selectedColor == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Notification'),
                          content: Text('Please enter complete information'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
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
                    if(_selectedToDateTime!.isBefore(_selectedFromDateTime!)) {
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Notification'),
                          content: Text('The start date must be before the end date'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                    }
                    CreateNoteRequestModel model = CreateNoteRequestModel(
                        title: title.text,
                        description: description.text,
                        color: colorCode,
                        fromDate: formattedFromDateTime,
                        toDate: formattedToDateTime);
                    ApiService.createNote(model).then((response) => {
                          if (response.result)
                            {
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
            ],
          ),
        ));
  }
}
