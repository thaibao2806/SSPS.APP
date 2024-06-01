import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/components/notification/local_notification.dart';
import 'package:ssps_app/components/todolist/Dialog_add_card.dart';
import 'package:ssps_app/components/todolist/Dialog_add_todonote.dart';
import 'package:ssps_app/components/todolist/Dialog_delete_card.dart';
import 'package:ssps_app/components/todolist/Dialog_delete_todonote.dart';
import 'package:ssps_app/components/todolist/Dialog_swap_cart.dart';
import 'package:ssps_app/components/todolist/Dialog_update_cart.dart';
import 'package:ssps_app/components/todolist/Dialog_update_todonote.dart';
import 'package:ssps_app/models/todolist/get_all_todo_response_model.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:intl/intl.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/widget/drawer_widget.dart';

class TodolistPage extends StatefulWidget {
  TodolistPage({Key? key}) : super(key: key);

  @override
  State<TodolistPage> createState() => _TodolistPage();
}

class _TodolistPage extends State<TodolistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Data> todoList = [];
  bool isDataLoaded = false;
  String? firstName;
  String? lastName;
  String? dropdownValue = 'Item 1';

  @override
  void initState() {
    super.initState();
    _decodeToken();
    refreshTodoList();
  }

  void refreshTodoList() {
    ApiService.getAllTodo().then((response) {
      if (response.result) {
        print(response.result);
        setState(() {
          todoList = response.data;
        });
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

  int daysBetween(DateTime fromDate, DateTime toDate) {
    return toDate.difference(fromDate).inDays;
  }

// Tính phần trăm tiến độ từ fromDate đến toDate
  double calculateProgress(DateTime fromDate, DateTime toDate) {
    DateTime now = DateTime.now();
    int totalDays = daysBetween(fromDate, toDate);
    int passedDays =
        toDate.isBefore(now) ? totalDays : daysBetween(fromDate, now);
    double progress = (totalDays != 0) ? (passedDays / totalDays) * 100 : 100;
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff3498DB),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Todolist",
            style: TextStyle(color: Colors.white),
          ),
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
                            Navigator.push(
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
          padding: EdgeInsets.only(top: 5, left: 10, right: 10),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final todo = todoList[index];
              final fromDate = DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(todo.fromDate!));
              final toDate =
                  DateFormat('dd-MM-yyyy').format(DateTime.parse(todo.toDate!));
              DateTime currentDate = DateTime.now();
              bool isFromDateLate =
                  DateTime.parse(todo.fromDate!).isBefore(currentDate);
              bool isToDateLate =
                  DateTime.parse(todo.toDate!).isBefore(currentDate);
              double progress = calculateProgress(
                  DateTime.parse(todo.fromDate!), DateTime.parse(todo.toDate!));

              // if(progress >= 60) {
              //   LocalNotifications.showSimpleNotification(title: "SSPS", body: "TodoList: ${todo.title} has reached 50%.", payload: "Todo");
              // }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                      8.0), // Đặt giá trị radius tùy ý ở đây
                ),
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  - ${progress.toStringAsFixed(2)}%
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${todo.title ?? ""}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: _scaffoldKey.currentContext!,
                                    builder: (context) {
                                      return AddCardDialog(
                                        toDoNoteId: todo.id,
                                        onDeleteSuccess: () {
                                          refreshTodoList();
                                        },
                                      );
                                    });
                              },
                              icon: Icon(Icons.add, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: _scaffoldKey.currentContext!,
                                    builder: (context) {
                                      return UpdateDialog(
                                        onDeleteSuccess: () {
                                          refreshTodoList();
                                        },
                                        todo: todo,
                                      );
                                    });
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: _scaffoldKey.currentContext!,
                                    builder: (context) {
                                      return DeleteColumnDialog(
                                        todoId: todo.id,
                                        onDeleteSuccess: () {
                                          // Call the API to refresh the todo list here
                                          refreshTodoList();
                                        },
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete, color: Colors.red[400]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          fromDate,
                          style: TextStyle(
                            color: isToDateLate ? Colors.red : Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('-'),
                        SizedBox(
                            width: 10), // Khoảng cách giữa From Date và To Date
                        Text(
                          toDate,
                          style: TextStyle(
                            color: isToDateLate ? Colors.red : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildCardWidgets(todo),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Column(children: [
              const MyHeaderDrawer(),
              MyDrawerList(context),
            ]),
          )),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Builder(
              builder: (BuildContext context) {
                return SpeedDial(
                  // animatedIcon: AnimatedIcons.menu_close,
                  icon: Icons.add,
                  activeIcon: Icons.close,
                  backgroundColor: Color.fromARGB(255, 57, 161, 247),
                  overlayColor: Colors.black,
                  foregroundColor: Colors.white,
                  spaceBetweenChildren: 10,
                  overlayOpacity: 0.4,
                  children: [
                    SpeedDialChild(
                        child: Icon(Icons.event),
                        backgroundColor: Color.fromARGB(255, 57, 161, 247),
                        foregroundColor: Colors.white,
                        label: "Add todo",
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  onDeleteSuccess: () {
                                    refreshTodoList();
                                  },
                                );
                              });
                        }),
                    SpeedDialChild(
                      child: Icon(Icons.chat),
                      backgroundColor: Color.fromARGB(255, 57, 161, 247),
                      foregroundColor: Colors.white,
                      label: "Chat",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessengerPage()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ));
  }

  List<Widget> _buildCardWidgets(Data todo) {
    Color cardColor = todo.color != null
        ? Color(int.parse('0xFF${todo.color}'))
        : Colors.white;

    return todo.cards.map((card) {
      return Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${card.title ?? ""}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      child: Icon(Icons.swap_vert, color: Colors.white),
                      onSelected: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          ApiService.swapCart(card.id, todo.id, dropdownValue)
                              .then((response) => {
                                    if (response.result)
                                      {
                                        refreshTodoList(),
                                      }
                                  });
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return todoList.map((todo) {
                          return PopupMenuItem<String>(
                            value: todo.id,
                            child: Text(todo.title!),
                          );
                        }).toList();
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateCardDialog(
                                  toDoNoteId: todo.id,
                                  onDeleteSuccess: () {
                                    ApiService.getAllTodo().then((response) {
                                      if (response.result) {
                                        setState(() {
                                          todoList = response.data;
                                        });
                                      }
                                    }).catchError((error) {
                                      print('Error: $error');
                                    });
                                  },
                                  cardId: card.id,
                                  title: card.title,
                                  description: card.description);
                            });
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteCardDialog(
                                todoId: todo.id,
                                cardId: card.id,
                                onDeleteSuccess: () {
                                  refreshTodoList();
                                },
                              );
                            });
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Text(
              card.description ?? "",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ],
        ),
      );
    }).toList();
  }
}
