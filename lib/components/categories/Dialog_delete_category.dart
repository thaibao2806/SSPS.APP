import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/categories/delete_category_request_model.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/models/categories/update_category_request_model.dart';
import 'package:ssps_app/models/categories/update_category_request_model.dart' as Categories;
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart' as ToDoCard;
import 'package:flutter/material.dart' as Material;
import 'package:ssps_app/service/api_service.dart';


class DeleteCategoriesDialog extends StatefulWidget {
  final Function() onDeleteSuccess;
  final String? id;
  const DeleteCategoriesDialog({  required this.onDeleteSuccess, Key? key, this.id, }): super(key: key);

  @override
  _DeleteCategoriesDialog createState() => _DeleteCategoriesDialog();
}

class _DeleteCategoriesDialog extends State<DeleteCategoriesDialog> {

  @override
  void initState() {
    super.initState();
    // Set initial values for start date, end date, and selected color
  }

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final description = TextEditingController();
    bool isTitleEmpty = false;
    bool isDescriptionEmpty = false;
    bool isError = false;
    return AlertDialog(
      title: Text('Delete category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Are you sure you want to delete?")
          
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
            DeleteCategoryRequestModel model = DeleteCategoryRequestModel(id: widget.id);
                      ApiService.deleteCategory(model).then((response) {
                        if(response.result) {
                          widget.onDeleteSuccess();
                          Navigator.of(context).pop();
                        }
                      });           
          },
          child: Text('Yes', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
