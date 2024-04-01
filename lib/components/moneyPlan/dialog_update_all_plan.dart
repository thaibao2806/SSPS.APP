import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/notes/create_note_request_model.dart';
import 'package:ssps_app/service/api_service.dart';

class updateAllMoneyPlan extends StatefulWidget {
  final Function getNote;
  const updateAllMoneyPlan({super.key, required this.getNote});

  @override
  State<updateAllMoneyPlan> createState() => _updateAllMoneyPlanState();
}

class _updateAllMoneyPlanState extends State<updateAllMoneyPlan> {
  final expectAmounts = TextEditingController();
  final currencyUnit = TextEditingController();
  final name = TextEditingController();
  final expectAmount = TextEditingController();
  final priority = TextEditingController();
  final categoryId = TextEditingController();
  DateTime? _selectedFromDateTime;
  DateTime? _selectedToDateTime;
  Color _selectedColor = Colors.black;
  int numberOfSections = 1;
  TextEditingController expectAmountsController = TextEditingController();
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> expectControllers = [];
  List<String?> dropdownValues = [];
  List<GlobalKey> keys = []; // Danh sách các key cho mỗi dòng
  List<Widget> rows = [];

  @override
  void initState() {
    super.initState();
    // Thêm một dòng ban đầu
    _addRow();
  }

  void _addRow() {
    TextEditingController titleController = TextEditingController();
    TextEditingController expectController = TextEditingController();
    String selectedValue = "Normal";

    titleControllers.add(titleController);
    expectControllers.add(expectController);
    dropdownValues
        .add("Normal"); // Đặt giá trị mặc định là "Normal" cho DropdownButton

    GlobalKey key = GlobalKey(); // Tạo key mới cho mỗi dòng
    keys.add(key); // Thêm key vào danh sách
    setState(() {
      rows.add(
        Column(
          children: [
            Row(
              key: key, // Gán key cho dòng
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: expectController,
                      decoration: InputDecoration(
                        labelText: 'Expect',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category"),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedValue, // Giá trị mặc định
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue =
                          newValue!; // Cập nhật giá trị khi người dùng chọn
                    });
                  },
                  items: <String>['Highly', 'Medium', 'Normal']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text("Priority"),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedValue, // Giá trị mặc định
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue =
                          newValue!; // Cập nhật giá trị khi người dùng chọn
                    });
                  },
                  items: <String>['Highly', 'Medium', 'Normal']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeRow(key); // Sử dụng key để xóa dòng
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void _removeRow(GlobalKey key) {
    int index = keys.indexOf(key); // Xác định chỉ mục của dòng cần xóa
    if (index != -1) {
      setState(() {
        titleControllers.removeAt(index);
        expectControllers.removeAt(index);
        dropdownValues.removeAt(index);
        keys.removeAt(index); // Xóa key khỏi danh sách
        rows.removeWhere(
            (widget) => widget.key == key); // Xóa dòng có key tương ứng
      });
    }
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
    String dropdownValue = 'Normal';
    // return LayoutBuilder(builder: (context, constraints) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: expectAmounts,
                        decoration: InputDecoration(
                          labelText: 'ExpectAmount',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: expectAmounts,
                        decoration: InputDecoration(
                          labelText: 'CurrencyUnit',
                        ),
                      ),
                    ),
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Plan Details"),
                  ElevatedButton(
                    onPressed: () {
                      _addRow();
                    },
                    child: Text('Thêm phần tử'),
                  ),
                ],
              ),

              Column(children: rows),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(right: 8.0),
              //         child: TextField(
              //           controller: expectAmounts,
              //           decoration: InputDecoration(
              //             labelText: 'Title',
              //           ),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 8.0),
              //         child: TextField(
              //           controller: expectAmounts,
              //           decoration: InputDecoration(
              //             labelText: 'Expect',
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Category"),
              //     SizedBox(width: 20),
              //     DropdownButton<String>(
              //       value: dropdownValue,
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           dropdownValue = newValue!;
              //         });
              //       },
              //       items: <String>['Highly', 'Medium', 'Normal']
              //           .map((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //     ),
              //     Text("Priority"),
              //     SizedBox(width: 20),
              //     DropdownButton<String>(
              //       value: dropdownValue,
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           dropdownValue = newValue!;
              //         });
              //       },
              //       items: <String>['Highly', 'Medium', 'Normal']
              //           .map((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //     ),
              //   ],
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[300],
                ),
                onPressed: () {
                  if (expectAmounts.text.isEmpty) {
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
                    // CreateNoteRequestModel model = CreateNoteRequestModel(
                    //     title: title.text,
                    //     description: description.text,
                    //     color: colorCode,
                    //     fromDate: formattedFromDateTime,
                    //     toDate: formattedToDateTime);
                    // ApiService.createNote(model).then((response) => {
                    //       if (response.result)
                    //         {
                    //           widget.getNote(),
                    //           Navigator.of(context).pop(),
                    //         }
                    //     });
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
