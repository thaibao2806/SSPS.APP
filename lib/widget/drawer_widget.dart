import 'package:flutter/material.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/homePage.dart';
import 'package:ssps_app/pages/pomodoroPage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/pages/resetPassword.dart';
import 'package:ssps_app/pages/todolistPage.dart';
import 'package:ssps_app/service/shared_service.dart';

Widget MyDrawerList(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.only(top: 0.0),
    child: Column(
      children: [
        menuItem(context, 1, "Home", Icons.home_outlined, true, ReportPage()),
        menuItem(context, 2, "Expense management", Icons.calendar_month, false,
            HomePage()),
        menuItem(
            context, 3, "Todo", Icons.task_outlined, false, TodolistPage()),
        
        menuItem(context, 4, "Pomodoro", Icons.punch_clock_outlined, false,
            PomodoroPage()),
        menuItem(
            context, 5, "Account", Icons.person_outline, false, AccountPage()),
        Divider(),
        menuItem(
            context, 6, "Change Password", Icons.password, false, ResetPassword()),
        menuItem(context, 7, "Logout", Icons.logout_outlined, false, null),
      ],
    ),
  );
}

Widget menuItem(BuildContext context, int id, String title, IconData icon,
    bool selected, Widget? page) {
  return Material(
    child: InkWell(
      onTap: () {
        if (page != null) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        } else {
          SharedService.logout(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                )),
          ],
        ),
      ),
    ),
  );
}
