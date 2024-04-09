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
  List<Map<String, TextEditingController>> formDataList = [];
  List<Widget> formRows = [];
  List<ValueNotifier<String>> dropdownValues = [];
  List<ValueNotifier<String>> dropdownValues2 = [];
  List<String> dropdownItems = [];
  String initialDropdownValue = '';

  @override
  void initState() {
    super.initState();
    // Thêm một dòng ban đầu
    _getCategory();
    // dropdownValues.add(ValueNotifier(initialDropdownValue));

    // _addFormRow();

    // _buildFormRow();
  }

  _getCategory() {
    ApiService.getCategories().then((response) {
      setState(() {
        if (response.result) {
          dataCategories = response.data;
          Data category = dataCategories.firstWhere(
            (element) => element.name == dropdownValueCategory,
            // orElse: () => null,
          );
          dropdownItems =
              dataCategories.map((category) => category.name ?? "").toList();
          // Nếu cần, có thể gán giá trị mặc định cho dropdownValueCategory
          dropdownValueCategory =
              dropdownItems.isNotEmpty ? dropdownItems.first : "";
          // Nếu category khác null, gán idCategory bằng id của category
          // if (category != null) {
          //   idCategory = category.id;
          // }
          initialDropdownValue =
              dataCategories.isNotEmpty ? dataCategories.first.id ?? '' : '';
          _addFormRow();
        }
      });
    });
  }

  Widget _buildFormRow(Map<String, TextEditingController> formData, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: formData['field1'],
                decoration: InputDecoration(labelText: 'Title'),
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: TextFormField(
                controller: formData['field2'],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Expectual'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400],),
              onPressed: () {
                setState(() {
                  formDataList.removeAt(index);
                  formRows.removeAt(index);
                  dropdownValues.removeAt(index);
                  dropdownValues2.removeAt(index);
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: dropdownValues[index],
                builder: (context, value, child) {
                  return DropdownButton<String>(
                    value: value,
                    onChanged: (newValue) {
                      dropdownValues[index].value = newValue!;
                      print(newValue);
                    },
                    items: dataCategories.map<DropdownMenuItem<String>>(
                      (category) {
                        return DropdownMenuItem<String>(
                          value: category
                              .id, // Sử dụng id của category làm giá trị
                          child: Text(category.name!),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: dropdownValues2[index],
                builder: (context, value, child) {
                  return DropdownButton<String>(
                    value: value,
                    onChanged: (newValue) {
                      dropdownValues2[index].value = newValue!;
                    },
                    items: [
                      'Highly',
                      'Medium',
                      'Normal',
                    ].map<DropdownMenuItem<String>>(
                      (value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
            SizedBox(width: 25,),
          ],
        )
      ],
    );
  }

  void _addFormRow() {
    setState(() {
      Map<String, TextEditingController> newRow = {
        'field1': TextEditingController(),
        'field2': TextEditingController(),
      };
      dropdownValues.add(ValueNotifier(initialDropdownValue));
      dropdownValues2.add(ValueNotifier('Highly'));
      formDataList.add(newRow);
      formRows.add(_buildFormRow(newRow,
          formRows.length)); // Thêm Widget của dòng form vào danh sách formRows
    });
  }

  @override
  void dispose() {
    // Clean up the TextEditingController instances
    for (var formData in formDataList) {
      for (var controller in formData.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null)
      setState(() {
        if (isFrom) {
          _selectedFromDateTime = picked;
        } else {
          _selectedToDateTime = picked;
        }
      });
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
                        keyboardType: TextInputType.number,
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
                                // fontWeight: FontWeight.bold,
                                // color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            // controller: TextEditingController(
                            //   text: _selectedFromDateTime != null
                            //       ? _selectedFromDateTime.toString()
                            //       : '',
                            // ),
                            controller: TextEditingController(
                              text: _selectedFromDateTime != null
                                  ? DateFormat('dd, MMM, yyyy')
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
                            // controller: TextEditingController(
                            //   text: _selectedToDateTime != null
                            //       ? _selectedToDateTime.toString()
                            //       : '',
                            // ),
                            controller: TextEditingController(
                              text: _selectedToDateTime != null
                                  ? DateFormat('dd, MMM, yyyy')
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plan Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  IconButton(
                      onPressed: () {
                        _addFormRow();
                      },
                      icon: Icon(Icons.add, size: 30,)),
                ],
              ),
              Column(
                children: formRows,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[300],
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 20)
                ),
                onPressed: () {
                  if (expectAmounts.text.isEmpty ||
                      currencyUnit.text.isEmpty ||
                      _selectedFromDateTime == null ||
                      _selectedToDateTime == null) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Please enter title.'),
                    //   ),
                    // );
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
                    List<Map<String, dynamic>> data = [];
                    List<UsageMoneys> usageMoneys = [];

                    if(_selectedToDateTime!.isBefore(_selectedFromDateTime!)) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Notification'),
                              content: Text(
                                  'The start date must be before the end date'),
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

                    for (var formData in formDataList) {
                      if (formData['field1']!.text.isEmpty ||
                          formData['field2']!.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Notification'),
                              content: Text(
                                  'Please enter complete information'),
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
                        break;
                      }
                      return;
                    }
                    for (Map<String, TextEditingController> formData
                        in formDataList) {
                      UsageMoneys usageMoney = UsageMoneys(
                          name: formData['field1']?.text ?? '',
                          expectAmount:
                              double.tryParse(formData['field2']?.text ?? '0'),
                          priority: dropdownValues2[
                                          formDataList.indexOf(formData)]
                                      .value ==
                                  "Highly"
                              ? 1
                              : dropdownValues2[formDataList.indexOf(formData)]
                                          .value ==
                                      "Medium"
                                  ? 2
                                  : 3,
                          categoryId:
                              dropdownValues[formDataList.indexOf(formData)]
                                  .value);
                      usageMoneys.add(usageMoney);
                    }

                    print(usageMoneys);
                    double? expectedAmounts =
                        double.tryParse(expectAmounts.text);

                    

                    CreateMoneyPlanRequestModel model =
                        CreateMoneyPlanRequestModel(
                            currencyUnit: currencyUnit.text,
                            expectAmount: expectedAmounts,
                            fromDate: formattedFromDateTime,
                            toDate: formattedToDateTime,
                            usageMoneys: usageMoneys);
                    // CreateMoneyPlanRequestModel model =
                    //     _createMoneyPlanRequestModel();
                    ApiService.createMoneyPlan(model).then((value) {
                      print(value.result);
                      if (value.result) {
                        // print(value.msgDesc);
                        widget.getNote();
                        Navigator.of(context).pop();
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
