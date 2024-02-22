import 'package:flutter/material.dart';
import 'package:ssps_app/models/todolist/get_all_todo_response_model.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:intl/intl.dart';

class TodolistPage extends StatefulWidget {
  TodolistPage({Key? key}) : super(key: key);

  @override
  State<TodolistPage> createState() => _TodolistPage();
}

class _TodolistPage extends State<TodolistPage> {
  List<Data> todoList = [];

  @override
  void initState() {
    super.initState();
    ApiService.getAllTodo().then((response) {
      if (response.result) {
        setState(() {
          todoList = response.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2E4DF2),
        elevation: 0,
        centerTitle: true,
        title: const Text("Todolist"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final todo = todoList[index];
            final fromDate =
                DateFormat('dd-MM-yyyy').format(DateTime.parse(todo.fromDate!));
            final toDate =
                DateFormat('dd-MM-yyyy').format(DateTime.parse(todo.toDate!));
            DateTime currentDate = DateTime.now();
            bool isFromDateLate = DateTime.parse(todo.fromDate!).isBefore(currentDate);
            bool isToDateLate = DateTime.parse(todo.toDate!).isBefore(currentDate);
            return Container(
              
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0), // Đặt giá trị radius tùy ý ở đây
              ),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${todo.title ?? ""}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn vào biểu tượng thêm
                            },
                            icon: Icon(Icons.add, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn vào biểu tượng sửa
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              // Xử lý sự kiện khi nhấn vào biểu tượng xoá
                            },
                            icon: Icon(Icons.delete, color: Colors.red[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(fromDate, style: TextStyle(
                        color: isToDateLate ? Colors.red : Colors.black,
                      ),),
                      SizedBox(
                          width: 10),
                      Text('-'),
                       SizedBox(
                          width: 10),// Khoảng cách giữa From Date và To Date
                      Text(toDate, style: TextStyle(
                        color: isToDateLate ? Colors.red : Colors.black,
                      ),),
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
    );
  }

  List<Widget> _buildCardWidgets(Data todo) {
    Color cardColor = todo.color != null ? Color(int.parse('0xFF${todo.color}')) : Colors.white;
    
    return todo.cards.map((card) {
      return Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8.0), // Đặt giá trị radius tùy ý ở đây
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${card.title ?? ""}',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Xử lý sự kiện khi nhấn vào biểu tượng sửa
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        // Xử lý sự kiện khi nhấn vào biểu tượng xoá
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Text(card.description ?? "", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),),
          ],
        ),
      );
    }).toList();
  }
}
