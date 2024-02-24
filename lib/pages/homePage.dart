import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/pages/accountPage.dart';
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

  String? firstName;
  String? lastName;
  bool isDataLoaded = false;

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
              child: isDataLoaded // Kiểm tra xem dữ liệu đã được tải lên thành công hay chưa
                ? AvatarWidget(
                    firstName: firstName ?? '',
                    lastName: lastName ?? '',
                    width: 35,
                    height: 35,
                    fontSize: 15,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AccountPage()));
                    },
                  )
                : SizedBox(),),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.day,
        firstDayOfWeek: 6,
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

