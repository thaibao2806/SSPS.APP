import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart'
    as categoryData;
import 'package:ssps_app/models/moneyPlans/get_moneyPlan_byId_response_model.dart';
import 'package:ssps_app/models/moneyPlans/update_moneyPlan_request_model.dart';
import 'package:ssps_app/models/moneyPlans/update_usageMoney_request_model.dart';
import 'package:ssps_app/models/moneyPlans/update_usageMoney_request_model.dart'
    as updateMoneyPlan;
import 'package:ssps_app/models/notes/create_note_request_model.dart';
import 'package:ssps_app/service/api_service.dart';

class UpdateMoneyPlan extends StatefulWidget {
  final Function getNote;
  final Function getMoneyPla;
  final String moneyPlanId;
  final num expectualAmount;
  final num actualAmount;
  final String title;
  final int priority;
  final String? notes;
  const UpdateMoneyPlan({
    super.key,
    required this.getNote,
    required this.moneyPlanId,
    required this.expectualAmount,
    required this.actualAmount,
    required this.title,
    required this.priority,
    required this.notes,
    required this.getMoneyPla,
    // required this.notes,
  });

  @override
  State<UpdateMoneyPlan> createState() => _UpdateMoneyPlanState();
}

class _UpdateMoneyPlanState extends State<UpdateMoneyPlan> {
  DateTime? _selectedFromDateTime;
  DateTime? _selectedToDateTime;
  Color _selectedColor = Colors.black;
  final expectAmounts = TextEditingController();
  final title = TextEditingController();
  final actualualAmount = TextEditingController();
  Map<String, int> priorityMap = {
    'Highly': 1,
    'Medium': 2,
    'Normal': 3,
  };
  int selectedPriority = 1;
  String dropdownValue = 'Normal';
  String dropdownValue2 = 'Option A';
  String dropdownValueCategory = '';
  String? idCategory = "123";
  List<categoryData.Data> categories = [];
  List<Map<String, TextEditingController>> formDataList = [];
  List<Widget> formRows = [];
  List<ValueNotifier<String>> dropdownValues = [];
  List<ValueNotifier<String>> dropdownValues2 = [];
  List<String> dropdownItems = [];
  String initialDropdownValue = '';
  num totalActual = 0;
  num totalExpectual = 0;
  bool checkChangeActual = false;

  Widget _buildFormRow(Map<String, TextEditingController> formData, int index) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: formData['field1'],
                decoration: InputDecoration(labelText: 'Title'),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextFormField(
                controller: formData['field2'],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Expectual'),
                onChanged: (value) {
                  _calculateTotals();
                },
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextFormField(
                controller: formData['field3'],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Actual'),
                onChanged: (value) {
                  _calculateTotals();
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red[400],
              ),
              onPressed: () {
                setState(() {
                  formDataList.removeAt(index);
                  formRows.removeAt(index);
                  dropdownValues.removeAt(index);
                  dropdownValues2.removeAt(index);
                  _calculateTotals();
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
                    items: categories.map<DropdownMenuItem<String>>(
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
            SizedBox(
              width: 25,
            ),
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
            SizedBox(
              width: 25,
            ),
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
        'field3': TextEditingController(),
      };
      dropdownValues.add(ValueNotifier(initialDropdownValue));
      dropdownValues2.add(ValueNotifier('Highly'));
      formDataList.add(newRow);
      formRows.add(_buildFormRow(newRow,
          formRows.length)); // Thêm Widget của dòng form vào danh sách formRows
    });
  }

  void _calculateTotals() {
    totalActual = 0;
    totalExpectual = 0;
    for (var formData in formDataList) {
      totalActual += double.tryParse(formData['field3']?.text ?? '0') ?? 0;
      totalExpectual += double.tryParse(formData['field2']?.text ?? '0') ?? 0;
    }
    actualualAmount.text = totalActual.toString();
    expectAmounts.text = totalExpectual.toString();
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

  @override
  void initState() {
    super.initState();

    setState(() {
      print(widget.moneyPlanId);
      selectedPriority = widget.priority;
      dropdownValue = widget.priority == 1
          ? "Highly"
          : widget.priority == 2
              ? "Medium"
              : "Normal";
      String defaultCategoryName =
          categories.isNotEmpty ? categories.first.name ?? "" : "";
      dropdownValueCategory = widget.notes ?? defaultCategoryName;

      _getCategory();
      _getMoneyPlanById();
    });
  }

  @override
  void didUpdateWidget(covariant UpdateMoneyPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notes != oldWidget.notes) {
      String defaultCategoryName =
          categories.isNotEmpty ? categories.first.name ?? "" : "";
      dropdownValueCategory = widget.notes ?? defaultCategoryName;
    }
  }

  _getMoneyPlanById() {
    ApiService.getMoneyPlanById(widget.moneyPlanId).then((value) {
      if (value.result) {
        setState(() {
          print("test ${value.data!.actualAmount.toString()}");
          expectAmounts.text = value.data!.expectAmount.toString();
          actualualAmount.text = value.data!.actualAmount.toString();

          List<UsageMoneys> usageMoneys = value.data!.usageMoneys;
          for (int i = 0; i < usageMoneys.length; i++) {
            Map<String, TextEditingController> newRow = {
              'field1': TextEditingController(),
              'field2': TextEditingController(),
              'field3': TextEditingController(),
            };
            dropdownValues2.add(ValueNotifier('Highly'));
            dropdownValues.add(ValueNotifier(initialDropdownValue));
            formDataList.add(newRow);
            formRows.add(_buildFormRow(newRow, formDataList.length - 1));

            UsageMoneys item = usageMoneys[i];
            newRow['field1']!.text = item.name ?? '';
            newRow['field2']!.text = item.expectAmount.toString();
            newRow['field3']!.text = item.actualAmount.toString();
            if (categories.isNotEmpty) {
              categoryData.Data? category = categories.firstWhere(
                (element) => element.name == item.categoryName,
                // orElse: () => null,
              );
              print(item.actualAmount);
              // totalActual += item.actualAmount;
              if (category != null) {
                dropdownValues[i].value = category.id! ?? initialDropdownValue;
              }
            }
            dropdownValues2[i].value = item.priority == 1
                ? "Highly"
                : item.priority == 2
                    ? "Medium"
                    : "Normal";
            // dropdownValues[i].value = category.id!;
          }
          // actualualAmount.text = totalActual.toString();
          _calculateTotals();
        });
      }
    });
  }

  _getCategory() {
    ApiService.getCategories().then((value) {
      if (value.result) {
        setState(() {
          categories = value.data;
          categoryData.Data? category = categories.firstWhere(
            (element) => element.name == dropdownValueCategory,
            // orElse: () => null,
          );
          dropdownItems =
              categories.map((category) => category.name ?? "").toList();
          // Nếu cần, có thể gán giá trị mặc định cho dropdownValueCategory
          dropdownValueCategory =
              dropdownItems.isNotEmpty ? dropdownItems.first : "";
          // Nếu category khác null, gán idCategory bằng id của category
          if (category != null) {
            idCategory = category.id;
          }
          initialDropdownValue =
              categories.isNotEmpty ? categories.first.id ?? '' : '';
        });
      }
    });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: expectAmounts,
                        readOnly: true,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'ExpectAmonut',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: actualualAmount,
                        readOnly: true,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'ActualAmount',
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkChangeActual = true;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Plan details: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      // _addCustomRow();
                      _addFormRow();
                    },
                    icon: Icon(
                      Icons.add,
                      size: 30,
                    )),
              ]),
              Column(
                children: formRows,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue[300],
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 20)),
                onPressed: () {
                  if (expectAmounts.text.isEmpty ||
                      actualualAmount.text.isEmpty) {
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
                  }

                  List<Map<String, dynamic>> data = [];
                  List<Usages> usages = [];
                  bool checkAmount = false;

                  // Lặp qua danh sách các dòng form để tạo đối tượng từ dữ liệu nhập
                  for (Map<String, TextEditingController> formData
                      in formDataList) {
                    if (double.tryParse(formData['field2']?.text ?? '0')! <
                        double.tryParse(formData['field3']?.text ?? '0')!) {
                      checkAmount = true;
                    }
                    // Tạo đối tượng từ dữ liệu nhập của mỗi dòng form
                    Usages usage = Usages(
                      name: formData['field1']?.text ?? '',
                      expectAmount:
                          double.tryParse(formData['field2']?.text ?? '0'),
                      actualAmount:
                          double.tryParse(formData['field3']?.text ?? '0'),
                      priority: dropdownValues2[formDataList.indexOf(formData)]
                                  .value ==
                              "Highly"
                          ? 1
                          : dropdownValues2[formDataList.indexOf(formData)]
                                      .value ==
                                  "Medium"
                              ? 2
                              : 3,
                      categoryId:
                          dropdownValues[formDataList.indexOf(formData)].value,
                    );
                    totalActual +=
                        double.tryParse(formData['field3']?.text ?? '0')!
                            .toDouble();

                    // Thêm đối tượng Usages vào danh sách chứa dữ liệu
                    usages.add(usage);
                  }

                  double? expectedAmounts = double.tryParse(expectAmounts.text);
                  double? actualAmounts = double.tryParse(actualualAmount.text);
                  if (checkChangeActual) {
                    actualAmounts = double.tryParse(actualualAmount.text);
                  } else {
                    actualAmounts = totalActual.toDouble();
                  }
                  if (checkAmount || (expectedAmounts! < actualAmounts!)) {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        "The actual amount is greater than the expected amount",
                        style: TextStyle(fontSize: 18),
                      ),
                      dismissDirection: DismissDirection.up,
                      backgroundColor: Color.fromARGB(255, 244, 224, 93),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 180,
                          left: 10,
                          right: 10),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  UpdateMoneyPlanRequestModels model =
                      UpdateMoneyPlanRequestModels(
                    id: widget.moneyPlanId,
                    status:
                        "null", // Bạn có thể gán giá trị cho trường này nếu cần
                    expectAmount: expectedAmounts,
                    actualAmount: actualAmounts,
                    day: _selectedFromDateTime?.day ?? 0,
                    month: _selectedFromDateTime?.month ?? 0,
                    year: _selectedFromDateTime?.year ?? 0,
                    usages: usages,
                  );

                  print(usages);
                  ApiService.updateMoneyPlans(model).then((value) {
                    if (value.result) {
                      widget.getMoneyPla();
                      widget.getNote();
                      Navigator.of(context).pop();
                    }
                  });

                  // UpdateMoneyPlanRequestModels model = UpdateMoneyPlanRequestModels(id: widget.moneyPlanId, status: null, expectAmount: expectedAmounts, actualAmount: actualAmounts, day: day, month: month, year: year, usages: usages);

                  // data bây giờ là một mảng các đối tượng có cấu trúc như bạn mong muốn
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red[300],
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 20)),
                onPressed: () {
                  if (expectAmounts.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter title.'),
                      ),
                    );
                  } else {
                    ApiService.deleteMoneyPlan(widget.moneyPlanId)
                        .then((response) {
                      print(response.msgDesc);

                      if (response.result) {
                        widget.getNote();
                        widget.getMoneyPla();
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  ;
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
