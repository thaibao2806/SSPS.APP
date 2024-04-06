import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart'
    as categoryData;
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
  String dropdownValueCategory = 'Food & Beverage';
  String? idCategory = "123";
  List<categoryData.Data> categories = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.moneyPlanId);
      title.text = widget.title;
      expectAmounts.text = widget.expectualAmount.toString();
      actualualAmount.text = widget.actualAmount.toString();
      selectedPriority = widget.priority;
      dropdownValue = widget.priority == 1
          ? "Highly"
          : widget.priority == 2
              ? "Medium"
              : "Normal";
      dropdownValueCategory = widget.notes!;
      _getMoneyPlanById ();
      _getCategory();
    });
  }

  @override
  void didUpdateWidget(covariant UpdateMoneyPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notes != oldWidget.notes) {
      dropdownValueCategory = widget.notes!;
    }
  }

  _getMoneyPlanById () {
    ApiService.getMoneyPlanById(widget.moneyPlanId).then((value) {
      if(value.result) {
        print(value.data);
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

          // Nếu category khác null, gán idCategory bằng id của category
          if (category != null) {
            idCategory = category.id;
          }
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
              TextField(
                controller: title,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: expectAmounts,
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'ActualAmount',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),

                      // color: Color.fromARGB(41, 229, 228, 228),
                    ),
                    child: DropdownButton<categoryData.Data>(
                      value: categories.isNotEmpty
                          ? categories.firstWhere(
                              (element) =>
                                  element.name == dropdownValueCategory,
                              orElse: () => categories.first)
                          : null,
                      hint: Text('Category'),
                      onChanged: (categoryData.Data? newValue) {
                        setState(() {
                          print(newValue?.name ?? 'null');
                          dropdownValueCategory = newValue?.name ?? '';
                          idCategory = newValue?.id ?? '';
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<categoryData.Data>>(
                              (categoryData.Data category) {
                        return DropdownMenuItem<categoryData.Data>(
                          value: category,
                          child: Text(category.name!),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    margin: EdgeInsets.only(left: 40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromARGB(135, 223, 222, 222),
                      //     spreadRadius: 1,
                      //     blurRadius: 1,
                      //     offset: Offset(0, 3),
                      //   ),
                      // ],
                      // color: Color.fromARGB(41, 229, 228, 228),
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          print(priorityMap[newValue!]!);
                          dropdownValue = newValue!;
                          selectedPriority = priorityMap[newValue!]!;
                        });
                      },
                      items: priorityMap.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[300],
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (expectAmounts.text.isEmpty || title.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter title.'),
                      ),
                    );
                  } else {
                    double? expectedAmounts =
                        double.tryParse(expectAmounts.text);
                    double? actualAmounts =
                        double.tryParse(actualualAmount.text);

                    if (expectedAmounts == null || actualAmounts == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter valid numbers for expected and actual amounts.'),
                        ),
                      );
                      return;
                    }
                    if (expectedAmounts < actualAmounts) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'The expected amount is greater than the actual amount'),
                        ),
                      );
                    }

                    List<updateMoneyPlan.Data> data = [
                      updateMoneyPlan.Data(
                        name: title.text,
                        expectAmount: expectedAmounts,
                        actualAmount: actualAmounts,
                        priority: selectedPriority,
                        categoryId: idCategory,
                      ),
                    ];
                    UpdateMoneyPlanRequestModel model =
                        UpdateMoneyPlanRequestModel(
                            moneyPlanId: widget.moneyPlanId, data: data);
                    ApiService.updateMoneyPlan(model).then((response) {
                      print(response.msgDesc);

                      if (response.result) {
                        widget.getMoneyPla();
                        widget.getNote();
                        Navigator.of(context).pop();
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
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300],
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
                    ApiService.deleteMoneyPlan(widget.moneyPlanId)
                        .then((response) {
                      print(response.msgDesc);

                      if (response.result) {
                        widget.getMoneyPla();
                        widget.getNote();
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
