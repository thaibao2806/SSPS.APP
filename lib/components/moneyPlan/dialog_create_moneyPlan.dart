import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/models/moneyPlans/create_moneyPlan_request_model.dart';
import 'package:ssps_app/models/notes/create_note_request_model.dart';
import 'package:ssps_app/service/api_service.dart';

class CreateMoneyPlan extends StatefulWidget {
  final Function getNote;
  const CreateMoneyPlan({super.key, required this.getNote});

  @override
  State<CreateMoneyPlan> createState() => _CreateMoneyPlanState();
}

class _CreateMoneyPlanState extends State<CreateMoneyPlan> {
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
  List<String?> selectedValues = [];
  Map<String, int> priorityMap = {
    'Highly': 1,
    'Medium': 2,
    'Normal': 3,
  };
  int selectedPriority = 1;
  String dropdownValueCategory = 'Food & Beverage';
  List<Data> dataCategories = [];

  @override
  void initState() {
    super.initState();
    // Thêm một dòng ban đầu
    _addCustomRow();
    _getCategory();
  }

  _getCategory() {
    ApiService.getCategories().then((response) {
      setState(() {
        if (response.result) {
          dataCategories = response.data;
        }
      });
    });
  }

  void _addCustomRow() {
    TextEditingController titleController = TextEditingController();
    TextEditingController expectController = TextEditingController();
    String selectedValue = "Normal";

    titleControllers.add(titleController);
    expectControllers.add(expectController);
    selectedValues.add(selectedValue);
    dropdownValues.add("Normal");

    GlobalKey key = GlobalKey();
    keys.add(key);

    setState(() {
      rows.add(
        Column(
          children: [
            Row(
              key: key,
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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeCustomRow(key); // Truyền key vào hàm xoá
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

// Thêm hàm _removeCustomRow để xoá dòng chính xác
  void _removeCustomRow(GlobalKey key) {
    int index = keys.indexOf(key);
    if (index != -1) {
      setState(() {
        titleControllers.removeAt(index);
        expectControllers.removeAt(index);
        dropdownValues.removeAt(index);
        keys.removeAt(index);
        rows.removeAt(index);
        selectedValues.removeAt(index);
      });
    }
  }

  CreateMoneyPlanRequestModel _createMoneyPlanRequestModel() {
  List<UsageMoneys> usageMoneys = [];

  for (int i = 0; i < titleControllers.length; i++) {
    UsageMoneys usageMoney = UsageMoneys(
      name: titleControllers[i].text,
      expectAmount: int.parse(expectControllers[i].text),
      priority: 1,
      categoryId: "10c91950-e888-40f3-a24c-3a7b9eb29109",
    );
    usageMoneys.add(usageMoney);
  }

  return CreateMoneyPlanRequestModel(
    expectAmount: int.parse(expectAmounts.text),
    currencyUnit: currencyUnit.text,
    fromDate: _selectedFromDateTime.toString(),
    toDate: _selectedToDateTime.toString(),
    usageMoneys: usageMoneys,
  );
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
                        controller: currencyUnit,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plan Details"),
                  IconButton(
                      onPressed: () {
                        _addCustomRow();
                      },
                      icon: Icon(Icons.add)),
                  DropdownButton<Data>(
                    value: dataCategories.isNotEmpty
                        ? dataCategories.firstWhere(
                            (element) => element.name == dropdownValueCategory,
                            orElse: () => dataCategories.first)
                        : null,
                    hint: Text('Category'),
                    onChanged: (Data? newValue) {
                      setState(() {
                        print(newValue?.name ?? 'null');
                        dropdownValueCategory = newValue?.name ?? '';
                        // idCategory = newValue?.id ?? '';
                      });
                    },
                    items: dataCategories
                        .map<DropdownMenuItem<Data>>((Data category) {
                      return DropdownMenuItem<Data>(
                        value: category,
                        child: Text(category.name!),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(children: rows),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[300],
                  minimumSize: Size(double.infinity, 50),
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
                      
                     CreateMoneyPlanRequestModel model = _createMoneyPlanRequestModel();
                     ApiService.createMoneyPlan(model).then((value) {
                      print(value.msgDesc);
                        if(value.result) {
                          print(value.msgDesc);
                        }
                     });
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
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
