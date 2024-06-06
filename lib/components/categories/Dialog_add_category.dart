import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/models/categories/update_category_request_model.dart';
import 'package:ssps_app/models/categories/update_category_request_model.dart' as Categories;
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart' as ToDoCard;
import 'package:flutter/material.dart' as Material;
import 'package:ssps_app/service/api_service.dart';


class AddCategoriesDialog extends StatefulWidget {
  final Function() onDeleteSuccess;
  final List<Data> dataCategories;
  const AddCategoriesDialog({  required this.onDeleteSuccess, Key? key, required this.dataCategories,}): super(key: key);

  @override
  _AddCategoriesDialog createState() => _AddCategoriesDialog();
}

class _AddCategoriesDialog extends State<AddCategoriesDialog> {

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
      title: Text('Add category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: title,
            // onChanged: (value) {
            //   setState(() {
            //     isTitleEmpty = value.isEmpty;
            //   });
            // },
            decoration: InputDecoration(
              labelText: 'Title',
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
            
            if(title.text.isEmpty ) {
              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter name.'),
                            ),
                          );
            } else {
              Categories.Categories newCategory = Categories.Categories(
                            name: title.text,
                            isDefault: false,
                          );
                          List<Categories.Categories > categoryList = [newCategory];
                          widget.dataCategories.forEach((category) {
                            categoryList.add(Categories.Categories(
                              name: category.name, // giả sử 'name' là một trường trong 'Data' mà bạn muốn sử dụng
                              isDefault: true,
                            ));
                          });
                          UpdateCategoryRequestModel model = UpdateCategoryRequestModel(categories: categoryList);
                          ApiService.createCategories(model).then((response) => {
                            print(response.result),
                            if(response.result) {
                              widget.onDeleteSuccess(),
                              Navigator.of(context).pop(),
                            }
                          });
            }
            
          },
          child: Text('Save', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
