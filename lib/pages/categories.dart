import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/categories/Dialog_add_category.dart';
import 'package:ssps_app/components/categories/Dialog_delete_category.dart';
import 'package:ssps_app/components/categories/Dialog_update_category.dart';
import 'package:ssps_app/models/categories/delete_category_request_model.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _Categories();
}

class _Categories extends State<Categories> {
  String? firstName;
  String? lastName;
  bool isDataLoaded = false;
  List<Data> dataCategories = [];

  @override
  void initState() {
    super.initState();
    _decodeToken();
    _getCategories();
  }

  _getCategories() async {
    ApiService.getCategories().then((response) => {
          if (response.result)
            {
              setState(() {
                dataCategories = response.data;
              }),
            }
        });
  }

  _decodeToken() async {
    var token = (await SharedService
        .loginDetails()); // Assume this method retrieves the token
    String? accessToken =
        token?.data?.accessToken; // Access token might be null
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      firstName = decodedToken['firstName'];
      lastName = decodedToken['lastName'];
      setState(() {
        isDataLoaded = true;
      });
    } else {
      print("Access token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff3498DB),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Categories",
            style: TextStyle(color: Colors.white),
          ),
          // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child:
                  isDataLoaded // Kiểm tra xem dữ liệu đã được tải lên thành công hay chưa
                      ? AvatarWidget(
                          firstName: firstName ?? '',
                          lastName: lastName ?? '',
                          width: 35,
                          height: 35,
                          fontSize: 15,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountPage()));
                          },
                        )
                      : SizedBox(),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color
          ),
          padding: EdgeInsets.all(8.0), // Padding around the list
          child: ListView.builder(
            itemCount: dataCategories.length,
            itemBuilder: (context, index) {
              final category = dataCategories[index];
              print(dataCategories.length);
              return Card(
                margin: EdgeInsets.symmetric(
                    vertical: 8.0), // Vertical space between categories
                child: ListTile(
                  title: Text('${category.name ?? ""}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[400],),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteCategoriesDialog(
                            id: category.id,
                            onDeleteSuccess: () {
                              _getCategories();
                            },
                          );
                        });
                    },
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return UpdateCategoriesDialog(
                            categoryName: category.name,
                            dataCategories: dataCategories,
                            onDeleteSuccess: () {
                              _getCategories();
                            },
                          );
                        });
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "Chat",
            backgroundColor: const Color.fromARGB(255, 57, 161, 247),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MessengerPage()));
            },
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            heroTag: "Add",
            backgroundColor: const Color.fromARGB(255, 57, 161, 247),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AddCategoriesDialog(
                      dataCategories: dataCategories,
                      onDeleteSuccess: () {
                        _getCategories();
                      },
                    );
                  });
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ]));
  }
}
