import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/pages/pomodoroPage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/pages/todolistPage.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/widget/drawer_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  CalendarView calendarView = CalendarView.month;
  CalendarController calendarController = CalendarController();
  bool isAllDayEvent = false;
  bool _isOpen = false;
  String? firstName;
  String? lastName;
  bool isDataLoaded = false;

  String dropdownValue = 'Month';

  // Danh sách các mục trong dropdown menu
  List<String> dropdownItems = ['Month', 'Week', 'Day', 'Today'];

  @override
  void initState() {
    super.initState();
    _decodeToken();
  }

  @override
  void dispose() {
    super.dispose();
    _decodeToken();
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
          "Home",
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: (){
                setState(() {
                  calendarView = CalendarView.day;
                    calendarController.view = calendarView;
                });
              }, child: Text("Today")),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                  // Xử lý khi một mục được chọn từ dropdown menu
                  // Ở đây bạn có thể thay đổi chế độ xem của lịch tùy thuộc vào giá trị mới được chọn
                  if (newValue == 'Month') {
                    calendarView = CalendarView.month;
                    calendarController.view = calendarView;
                  } else if (newValue == 'Week') {
                    calendarView = CalendarView.week;
                    calendarController.view = calendarView;
                  } else if (newValue == 'Day') {
                    calendarView = CalendarView.day;
                    calendarController.view = calendarView;
                  } else if (newValue == 'Today') {
                    calendarView = CalendarView.day;
                    calendarController.view = calendarView;
                  }
                },
                items: dropdownItems
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: SfCalendar(
                view: calendarView,
                monthViewSettings: MonthViewSettings(showAgenda: true),
                controller: calendarController,
                firstDayOfWeek: 6,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.blue,
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.mail),
                    backgroundColor: Colors.red,
                    label: "Add event"),
                SpeedDialChild(
                    child: Icon(Icons.copy),
                    backgroundColor: Colors.green,
                    label: "Mail"),
                SpeedDialChild(
                  child: Icon(Icons.chat),
                  backgroundColor: Colors.orange,
                  label: "Chat",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessengerPage()));
                  },
                )
              ]),
        ],
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
    );
  }
}
