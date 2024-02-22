import 'package:flutter/material.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/pomodoroPage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/pages/todolistPage.dart';
import 'package:ssps_app/service/shared_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
        title: const Text("Home"),
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {
        }, icon: const Icon(Icons.person))],
      ),
      body: SfCalendar(
        view: CalendarView.day,
        firstDayOfWeek: 6,
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(context),
              ]
              ),
          ) 
          ),
      ),
    );
  }
}

Widget MyDrawerList(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 15.0),
    child: Column(
      children: [
        menuItem(context, 1, "Home", Icons.home_outlined, true, HomePage() ),
        menuItem(context, 2, "Todo", Icons.task_outlined, false, TodolistPage() ),
        menuItem(context, 3, "Report", Icons.task_outlined, false, ReportPage() ),
        menuItem(context, 4, "Pomodoro", Icons.task_outlined, false, PomodoroPage() ),
        menuItem(context, 5, "Account", Icons.person_outline, false, AccountPage() ),
        Divider(),
        menuItem(context, 6, "Logout", Icons.logout_outlined, false, null ),
      ],
    ),
  );
}

Widget menuItem(BuildContext context, int id, String title, IconData icon, bool selected, Widget? page) {
  return Material(
    child: InkWell(
      onTap: () {
        if(page != null) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }else {
          SharedService.logout(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Icon(icon, size: 20,color: Colors.black,),
            ),
            Expanded(flex: 3, child: Text(title, style: TextStyle(color: Colors.black, fontSize: 16.0),)),
          ],
        ),
      ),
    ),
  );
}