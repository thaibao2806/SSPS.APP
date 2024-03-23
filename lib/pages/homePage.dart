import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
  String dropdownValue = 'Day';
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();

  // Danh sách các mục trong dropdown menu
  List<String> dropdownItems = ['Month', 'Week', 'Day', 'Today'];
  List<Appointment> appointments = [];

  String firstDateFormatted = '';
  String lastDateFormatted = '';

// Hàm để chuyển đổi ngày thành chuỗi theo định dạng yyyy-mm-dd
  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _decodeToken();
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

  getNote(String? fromDate, String? toDate) {
    ApiService.getNote(fromDate, toDate).then((response) {
      if (response.result) {
        setState(() {
          appointments
              .clear(); // Xóa sự kiện hiện tại trước khi thêm sự kiện mới
          // Loop qua danh sách các sự kiện từ API và thêm vào danh sách appointments
          for (var note in response.data) {
            print(note.fromDate);
            if (note.fromDate != null && note.toDate != null) {
              appointments.add(Appointment(
                id: note.id,
                from: DateTime.parse(note.fromDate!),
                to: DateTime.parse(note.toDate!),
                eventName: note.title ?? '',
                background: hexToColor(note.color ?? 'D13333'),
                isAllDay: false,
                notes: note.description,
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
    // Xử lý logic khi người dùng nhấp vào một sự kiện trên lịch
    if (details.targetElement is CalendarElement &&
        details.appointments != null) {
      final Appointment tappedAppointment = details.appointments![0];
      // Lấy thông tin của sự kiện được nhấn
      String eventId = tappedAppointment.id ?? '';
      DateTime startTime = tappedAppointment.from;
      DateTime endTime = tappedAppointment.to;
      String? eventName = tappedAppointment.eventName;
      Color eventColor = tappedAppointment.background;
      bool isAllDay = tappedAppointment.isAllDay;
      String? notes = tappedAppointment.notes;
      print(notes);
      showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableSheetUpdate(
          getNote: () {
            firstDateFormatted = formatDate(firstDate);
            lastDateFormatted = formatDate(lastDate);
            getNote(firstDateFormatted, lastDateFormatted);
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
      // Xử lý thông tin sự kiện như mong muốn
    }
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
              Column(children: [
                Text("Expect: 10000"),
                Text("Actual: 10000"),
              ]),
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
                items:
                    dropdownItems.map<DropdownMenuItem<String>>((String value) {
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
              dataSource: MeetingDataSource(appointments),
              initialDisplayDate: currentDate,
              onTap: handleEventTap,
              onViewChanged: (ViewChangedDetails details) {
                print("Ngày được chọn: ${details}");
                print("Các ngày hiển thị trong tháng: ${details.visibleDates}");
                firstDate = details.visibleDates[0];
                lastDate =
                    details.visibleDates[details.visibleDates.length - 1];
                firstDateFormatted = formatDate(firstDate);
                lastDateFormatted = formatDate(lastDate);
                getNote(firstDateFormatted, lastDateFormatted);
              },
            ),
          ))
        ],
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.blue,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.event),
                  backgroundColor: Colors.red,
                  label: "Add plan"),
              SpeedDialChild(
                child: Icon(Icons.paste),
                backgroundColor: Colors.green,
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
                      return DraggableSheet(getNote: () {
                        firstDateFormatted = formatDate(firstDate);
                        lastDateFormatted = formatDate(lastDate);
                        getNote(firstDateFormatted, lastDateFormatted);
                      });
                    },
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.category),
                backgroundColor: Colors.green,
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
                backgroundColor: Colors.orange,
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
  String? notes; // Thêm thuộc tính notes vào class

  Appointment({
    this.id,
    required this.from,
    required this.to,
    required this.eventName,
    required this.background,
    required this.isAllDay,
    required this.notes, // Bổ sung tham số notes vào constructor
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
