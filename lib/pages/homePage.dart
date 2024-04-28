import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/moneyPlan/dialog_create_moneyPlan.dart';
import 'package:ssps_app/components/moneyPlan/dialog_update_moneyPlan.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/components/note/bottom_sheet_dialog_add_note.dart';
import 'package:ssps_app/components/note/bottom_sheet_dialog_update.dart';
import 'package:ssps_app/models/notes/get_note_response_model.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/categories.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/pages/pomodoroPage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/pages/todolistPage.dart';
import 'package:ssps_app/service/api_service.dart';
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
  DateTime currentDate = DateTime.now();
  String dropdownValue = 'Month';
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();

  // Danh sách các mục trong dropdown menu
  List<String> dropdownItems = ['Month', 'Week', 'Day'];
  List<Appointment> appointments = [];

  String firstDateFormatted = '';
  String lastDateFormatted = '';

  DateTime _currentDate = DateTime.now();

  num expectAmountTotal = 0;
  num actualAmountTotal = 0;
  String? currencyUnit;

// Hàm để chuyển đổi ngày thành chuỗi theo định dạng yyyy-mm-dd
  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _decodeToken();
    getMoneyPlan(formatDate(currentDate), formatDate(currentDate));
    getNote(formatDate(currentDate), formatDate(currentDate));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color hexToColor(String code) {
    String hex = code.startsWith('#') ? code.substring(1) : code;
    return Color(int.parse(hex, radix: 16) + 0xFF000000);
  }

  void _next() {
    if (calendarController != null) {
      calendarController.forward!();
    }
  }

  void _previous() {
    if (calendarController != null) {
      calendarController.backward!();
    }
  }

  void _today() {
    setState(() {
      calendarController.displayDate = DateTime.now();
      _currentDate = DateTime.now();
    });
  }

  getMoneyPlan(String? fromDate, String? toDate) {
    ApiService.getMoneyPlan(fromDate, toDate).then((response) {
      if (response.result) {
        print(response.result);
        expectAmountTotal = 0;
        actualAmountTotal = 0;
        for (var money in response.data) {
          setState(() {
            for (var usage in money.usageMoneys) {
              appointments.add(Appointment(
                id: money.id,
                from: DateTime.parse(money.date!),
                to: DateTime.parse(money.date!),
                eventName: usage.name ?? '',
                background: hexToColor(usage.expectAmount < usage.actualAmount
                    ? "ca4f4f"
                    : usage.priority == 1
                        ? '039BE5'
                        : usage.priority == 2
                            ? '33B679'
                            : '919191b2'),
                isAllDay: true,
                notes: usage.categoryName,
                expectAmount: usage.expectAmount,
                actualAmount: usage.actualAmount,
                priority: usage.priority,
              ));
            }
            currencyUnit = money.currencyUnit;
            if (money.expectAmount > 0) {
              expectAmountTotal += money.expectAmount;
              actualAmountTotal += money.actualAmount;
            } else {
              expectAmountTotal = 0;
              actualAmountTotal = 0;
            }
          });
        }

        print(expectAmountTotal);
        print(actualAmountTotal);
      }
    });
  }

  getNote(String? fromDate, String? toDate) {
    ApiService.getNote(fromDate, toDate).then((response) {
      if (response.result) {
        setState(() {
          appointments
              .clear(); // Xóa sự kiện hiện tại trước khi thêm sự kiện mới
          // Loop qua danh sách các sự kiện từ API và thêm vào danh sách appointments
          for (var note in response.data) {
            if (note.fromDate != null && note.toDate != null) {
              appointments.add(Appointment(
                id: note.id,
                from: DateTime.parse(note.fromDate!),
                to: DateTime.parse(note.toDate!),
                eventName: note.title ?? '',
                background: hexToColor(note.color ?? 'D13333'),
                isAllDay: false,
                notes: note.description,
                expectAmount: 0,
                actualAmount: 0,
                priority: 0,
              ));
            }
          }
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

  void handleEventTap(CalendarTapDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      DateTime selectedDate = details.date!;
      final Appointment tappedAppointment = details.appointments![0];
      List<Appointment> eventsOnSelectedDate = getEventsOnDate(selectedDate);
      

      if (dropdownValue == "Month") {
        // WidgetsBinding.instance!.addPostFrameCallback((_) {
        final Appointment tappedAppointment = details.appointments![0];
        String eventId = tappedAppointment.id ?? '';
        DateTime startTime = tappedAppointment.from;
        DateTime endTime = tappedAppointment.to;
        String? eventName = tappedAppointment.eventName;
        Color eventColor = tappedAppointment.background;
        bool isAllDay = tappedAppointment.isAllDay;
        String? notes = tappedAppointment.notes;
        num expectAmount = tappedAppointment.expectAmount!;
        num actualAmount = tappedAppointment.actualAmount!;
        int priority = tappedAppointment.priority;
        print(tappedAppointment.background);
        if (expectAmount > 0) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return UpdateMoneyPlan(
                getNote: () async {
                  firstDateFormatted = formatDate(firstDate);
                  lastDateFormatted = formatDate(lastDate);
                  await getMoneyPlan(firstDateFormatted, lastDateFormatted);
                },
                moneyPlanId: eventId,
                expectualAmount: expectAmount,
                actualAmount: actualAmount,
                title: eventName!,
                priority: priority,
                notes: notes!,
                getMoneyPla: () {
                  firstDateFormatted = formatDate(firstDate);
                  lastDateFormatted = formatDate(lastDate);
                  getNote(firstDateFormatted, lastDateFormatted);
                },
                // notes: notes ?? "",
              );
            },
          );
        } else {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return DraggableSheetUpdate(
                getNote: () {
                  firstDateFormatted = formatDate(firstDate);
                  lastDateFormatted = formatDate(lastDate);
                  getNote(firstDateFormatted, lastDateFormatted);
                  getMoneyPlan(firstDateFormatted, lastDateFormatted);
                },
                enventId: eventId,
                startTime: startTime,
                endTime: endTime,
                eventColor: eventColor,
                notes: notes,
                enventName: eventName,
              );
            },
          );
        }
      } else {
        final Appointment tappedAppointment = details.appointments![0];
        String eventId = tappedAppointment.id ?? '';
        DateTime startTime = tappedAppointment.from;
        DateTime endTime = tappedAppointment.to;
        String? eventName = tappedAppointment.eventName;
        Color eventColor = tappedAppointment.background;
        bool isAllDay = tappedAppointment.isAllDay;
        String? notes = tappedAppointment.notes;
        num expectAmount = tappedAppointment.expectAmount!;
        num actualAmount = tappedAppointment.actualAmount!;
        int priority = tappedAppointment.priority;
        print(tappedAppointment.background);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (expectAmount > 0) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return UpdateMoneyPlan(
                  getNote: () async {
                    actualAmountTotal = 0;
                    expectAmountTotal = 0;
                    firstDateFormatted = formatDate(firstDate);
                    lastDateFormatted = formatDate(lastDate);
                    getNote(firstDateFormatted, lastDateFormatted);

                    await getMoneyPlan(firstDateFormatted, lastDateFormatted);
                  },
                  moneyPlanId: eventId,
                  expectualAmount: expectAmount,
                  actualAmount: actualAmount,
                  title: eventName!,
                  priority: priority,
                  notes: notes!,
                  getMoneyPla: () {
                    firstDateFormatted = formatDate(firstDate);
                    lastDateFormatted = formatDate(lastDate);
                    getNote(firstDateFormatted, lastDateFormatted);
                    getMoneyPlan(firstDateFormatted, lastDateFormatted);
                  },
                  // notes: notes ?? "",
                );
              },
            );
          } else {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return DraggableSheetUpdate(
                  getNote: () {
                    firstDateFormatted = formatDate(firstDate);
                    lastDateFormatted = formatDate(lastDate);
                    getNote(firstDateFormatted, lastDateFormatted);
                    getMoneyPlan(firstDateFormatted, lastDateFormatted);
                  },
                  enventId: eventId,
                  startTime: startTime,
                  endTime: endTime,
                  eventColor: eventColor,
                  notes: notes,
                  enventName: eventName,
                );
              },
            );
          }
        });
      }
    }else {
      print(details.date);
      showModalBottomSheet(
                    // isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return DraggableSheet(getNote: () {
                        firstDateFormatted = formatDate(firstDate);
                        lastDateFormatted = formatDate(lastDate);
                        getNote(firstDateFormatted, lastDateFormatted);
                      }, startTime: details.date!, endTime: details.date!);
                    },
                  );
    }
  }

  List<Appointment> getEventsOnDate(DateTime date) {
    return appointments.where((event) {
      return event.from.year == date.year &&
          event.from.month == date.month &&
          event.from.day == date.day;
    }).toList();
  }
  // Schedule the state update to occur after the current build cycle completes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff3498DB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Expense management",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(41, 161, 161, 161),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromARGB(41, 229, 228, 228),
                      //     spreadRadius: 1,
                      //     blurRadius: 1,
                      //     offset: Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    height: 120,
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.payment,
                            size: 40,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Total expect: ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 42, 43, 42)),
                          ),
                          Text(
                            "${expectAmountTotal.toStringAsFixed(2)} $currencyUnit",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 81, 212, 85)),
                          ),
                        ],
                      ),
                    )),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(41, 161, 161, 161),
                    ),
                    height: 120,
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.money_outlined,
                            size: 40,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Total actual:",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 42, 43, 42))),
                          Text(
                              "${actualAmountTotal.toStringAsFixed(2)} $currencyUnit",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 81, 212, 85))),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: _previous,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: _next,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 157, 157, 157),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: DropdownButton<String>(
                      underline: const SizedBox(),
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
                  ),
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
                dataSource: MeetingDataSource(appointments),
                initialDisplayDate: currentDate,
                onTap: handleEventTap,
                onViewChanged: (ViewChangedDetails details) {
                  expectAmountTotal = 0;
                  actualAmountTotal = 0;
                  firstDate = details.visibleDates[0];
                  lastDate =
                      details.visibleDates[details.visibleDates.length - 1];
                  firstDateFormatted = formatDate(firstDate);
                  lastDateFormatted = formatDate(lastDate);
                  getNote(firstDateFormatted, lastDateFormatted);
                  getMoneyPlan(firstDateFormatted, lastDateFormatted);
                  _currentDate = details.visibleDates[0];
                },
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return SpeedDial(
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
                  label: "Add plan",
                  onTap: () {
                    showModalBottomSheet(
                      // isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return CreateMoneyPlan(getNote: () async {
                          firstDateFormatted = formatDate(firstDate);
                          lastDateFormatted = formatDate(lastDate);

                          actualAmountTotal = 0;
                          expectAmountTotal = 0;
                          getNote(firstDateFormatted, lastDateFormatted);

                          await getMoneyPlan(
                              firstDateFormatted, lastDateFormatted);
                        });
                      },
                    );
                  }),
              SpeedDialChild(
                child: Icon(Icons.paste),
                backgroundColor: Color.fromARGB(255, 57, 161, 247),
                foregroundColor: Colors.white,
                label: "Add note",
                onTap: () {
                  showModalBottomSheet(
                    // isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      final startTime = DateTime.now();
                      final endTime = DateTime.now();
                      return DraggableSheet(getNote: () {
                        firstDateFormatted = formatDate(firstDate);
                        lastDateFormatted = formatDate(lastDate);
                        getNote(firstDateFormatted, lastDateFormatted);
                      }, startTime: startTime, endTime: endTime);
                    },
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.category),
                backgroundColor: Color.fromARGB(255, 57, 161, 247),
                foregroundColor: Colors.white,
                label: "Category",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Categories()),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.chat),
                backgroundColor: Color.fromARGB(255, 57, 161, 247),
                foregroundColor: Colors.white,
                label: "Chat",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MessengerPage()),
                  );
                },
              ),
            ],
          );
        },
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

class Appointment {
  String? id;
  late DateTime from;
  late DateTime to;
  String? eventName;
  Color background;
  bool isAllDay;
  String? notes;
  num expectAmount;
  num actualAmount;
  int priority;

  Appointment({
    this.id,
    required this.from,
    required this.to,
    required this.eventName,
    required this.background,
    required this.isAllDay,
    required this.notes,
    required this.expectAmount,
    required this.actualAmount,
    required this.priority,
  });
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
