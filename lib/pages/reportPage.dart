import 'package:bottom_picker/resources/arrays.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/models/report/report_response_model.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/widget/drawer_widget.dart';
import 'package:bottom_picker/bottom_picker.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPage();
}

class _ReportPage extends State<ReportPage> {
  String? firstName;
  String? lastName;
  bool isDataLoaded = false;
  String? selectedValue = "Day";
  DateTime currentDate = DateTime.now();
  String? month;
  bool isMonthSelected = false;
  num totalExpectAmount = 0;
  num totalActualAmount = 0;
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  String? type = "YEAR";
  String? fromDate;
  String? toDate;
  DateTime firstDayOfMonth = DateTime.now();
  DateTime lastDayOfMonth = DateTime.now();
  List<ListDiagramData> listDiagramData = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    firstDayOfMonth = new DateTime(now.year, now.month, 1);
    lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    fromDate = formatMonthYear(firstDayOfMonth);
    toDate = formatMonthYear(lastDayOfMonth);
    dateRange = DateTimeRange(start: firstDayOfMonth, end: lastDayOfMonth);

    _decodeToken();
    _getData(type, fromDate, toDate);

    month = formatYear(currentDate);
  }

  @override
  void dispose() {
    super.dispose();
    _decodeToken();
  }

  _changeTypeDate(bool isType) {
    if (isType) {
      type = "MONTH";
      DateTime now = DateTime.now();
      firstDayOfMonth = new DateTime(now.year, now.month, 1);
      lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
      fromDate = formatMonthYear(firstDayOfMonth);
      toDate = formatMonthYear(lastDayOfMonth);
      _getData(type, fromDate, toDate);
    } else {
      type = "YEAR";
      _getData(type, fromDate, toDate);
      month = formatYear(firstDayOfMonth);
    }
  }

  _getData(String? type, String? fromDate, String? toDate) async {
    ApiService.report(type, fromDate, toDate).then((value) {
      if (value.result) {
        setState(() {
          print(value.data!.totalExpectMoney);
          print(value.data!.totalActualMoney);
          totalExpectAmount = value.data!.totalExpectMoney;
          totalActualAmount = value.data!.totalActualMoney;
          listDiagramData = value.data?.listDiagramData ?? [];
          listDiagramData.sort((a, b) => a.doM.compareTo(b.doM));
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

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    if (!isMonthSelected) {
      switch (value.toInt()) {
        case 1:
          text = 'Jan';
          break;
        case 2:
          text = 'Feb';
          break;
        case 3:
          text = 'Mar';
          break;
        case 4:
          text = 'Apr';
          break;
        case 5:
          text = 'May';
          break;
        case 6:
          text = 'Jun';
          break;
        case 7:
          text = 'Jul';
          break;
        case 8:
          text = 'Aug';
          break;
        case 9:
          text = 'Sep';
          break;
        case 10:
          text = 'Oct';
          break;
        case 11:
          text = 'Nov';
          break;
        case 12:
          text = 'Dec';
          break;
        default:
          text = '';
          break;
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 2,
        child: Text(text, style: style),
      );
    } else {
      switch (value.toInt()) {
        case 1:
          text = '1';
          break;
        case 2:
          text = '2';
          break;
        case 3:
          text = '3';
          break;
        case 4:
          text = '4';
          break;
        case 5:
          text = '5';
          break;
        case 6:
          text = '6';
          break;
        case 7:
          text = '7';
          break;
        case 8:
          text = '8';
          break;
        case 9:
          text = '9';
          break;
        case 10:
          text = '10';
          break;
        case 11:
          text = '11';
          break;
        case 12:
          text = '12';
          break;
        case 13:
          text = '13';
          break;
        case 14:
          text = '14';
          break;
        case 15:
          text = '15';
          break;
        case 16:
          text = '16';
          break;
        case 17:
          text = '17';
          break;
        case 18:
          text = '18';
          break;
        case 19:
          text = '19';
          break;
        case 20:
          text = '20';
          break;
        case 21:
          text = '21';
          break;
        case 22:
          text = '22';
          break;
        case 23:
          text = '23';
          break;
        case 24:
          text = '24';
          break;
        case 25:
          text = '25';
          break;
        case 26:
          text = '26';
          break;
        case 27:
          text = '27';
          break;
        case 28:
          text = '28';
          break;
        case 29:
          text = '29';
          break;
        case 30:
          text = '30';
          break;
        case 31:
          text = '31';
          break;
        default:
          text = '';
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 2,
        child: Text(text, style: style),
      );
    }
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  String formatMonthYear(DateTime dateString) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateString);
    return formattedDate;
  }

  String formatYear(DateTime dateString) {
    String formattedDate = DateFormat('yyyy').format(dateString);
    return formattedDate;
  }

  _openDatePicker(BuildContext context) {
    BottomPicker.date(
      title: "Select a year",
      dateOrder: DatePickerDateOrder.mdy,
      pickerTextStyle:
          const TextStyle(color: Color.fromARGB(255, 15, 15, 15), fontSize: 20),
      titleStyle: const TextStyle(fontSize: 20),
      onChange: (index) {
        print(formatYear(index));
        print(currentDate);
        setState(() {
          month = formatYear(index);
          type = "YEAR";
          fromDate = formatMonthYear(index);
          toDate = formatMonthYear(index);
          _getData(type, fromDate, toDate);
        });
      },
      bottomPickerTheme: BottomPickerTheme.blue,
    ).show(context);
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (newDateRange == null) return;

    setState(() {
      print(newDateRange);
      type = "MONTH";
      fromDate = formatMonthYear(newDateRange.start);
      toDate = formatMonthYear(newDateRange.end);
      dateRange = newDateRange;
      _getData(type, fromDate, toDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Overview",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(107, 104, 104, 104),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMonthSelected = !isMonthSelected;
                          _changeTypeDate(isMonthSelected);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[250],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color:
                                          isMonthSelected ? Colors.white : null,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Month',
                                        style: TextStyle(
                                          color: isMonthSelected
                                              ? const Color.fromARGB(
                                                  255, 6, 6, 6)
                                              : Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    )),
                              ),
                              TextSpan(
                                text: '  ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              WidgetSpan(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color:
                                        isMonthSelected ? null : Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Year',
                                      style: TextStyle(
                                        color: isMonthSelected
                                            ? Colors.white
                                            : Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(53, 105, 104, 104),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 120,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 80, // Đặt chiều rộng mong muốn
                              height: 80, // Đặt chiều cao mong muốn
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const Image(
                                  image:
                                      AssetImage('assets/images/expectual.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Icon(
                            //   Icons.payment_outlined,
                            //   size: 40,
                            // ),
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total expect",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 81, 212, 85)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      totalExpectAmount
                                          .toStringAsFixed(2)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(53, 105, 104, 104),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 120,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 80, // Đặt chiều rộng mong muốn
                              height: 80, // Đặt chiều cao mong muốn
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const Image(
                                  image:
                                      AssetImage('assets/images/tien-bac.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total actual",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 248, 213, 87)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    totalActualAmount
                                        .toStringAsFixed(2)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ])
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  // height: double.infinity,
                  // width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(138, 105, 104, 104),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                    child: Container(
                      height: 292, // Đặt chiều cao tùy ý tại đây
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  10.0), // Thêm padding 10px ở cả hai bên trái và phải
                          child: ClipRRect(
                              // Để tránh bo góc vượt qua phần border
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   "Total spending:",
                                          //   style: TextStyle(
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.w500),
                                          // ),
                                          // Text(
                                          //   "10000\$",
                                          //   style: TextStyle(fontSize: 20),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Visibility(
                                        visible: isMonthSelected,
                                        child: Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: GestureDetector(
                                              onTap: () => pickDateRange(),
                                              child: AbsorbPointer(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "From:",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                // labelText: 'From',
                                                                labelStyle: TextStyle(
                                                                    // fontWeight: FontWeight.bold,
                                                                    // color: Color.fromARGB(255, 0, 0, 0),
                                                                    ),
                                                              ),
                                                              // controller: TextEditingController(
                                                              //   text: _selectedToDateTime != null
                                                              //       ? _selectedToDateTime.toString()
                                                              //       : '',
                                                              // ),
                                                              controller:
                                                                  TextEditingController(
                                                                text:
                                                                    "${start.day}/${start.month}/${start.year}",
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   width: 10,
                                                    // ),
                                                    Text(
                                                      " - ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    // SizedBox(width: 15,),
                                                    // Icon(Icons.minimize),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "To:",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                // labelText: 'To',
                                                                labelStyle: TextStyle(
                                                                    // fontWeight: FontWeight.bold,
                                                                    // color: Color.fromARGB(255, 0, 0, 0),
                                                                    ),
                                                              ),
                                                              // controller: TextEditingController(
                                                              //   text: _selectedToDateTime != null
                                                              //       ? _selectedToDateTime.toString()
                                                              //       : '',
                                                              // ),
                                                              controller:
                                                                  TextEditingController(
                                                                text:
                                                                    "${end.day}/${end.month}/${end.year}",
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // {!isMonthSelected ? }
                                      Visibility(
                                        visible: !isMonthSelected,
                                        child: Expanded(
                                          child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            _openDatePicker(
                                                                context),
                                                        child: AbsorbPointer(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              SizedBox(
                                                                width: 210,
                                                              ),
                                                              Text(
                                                                "Year:",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    // labelText: 'From',
                                                                    labelStyle: TextStyle(
                                                                        // fontWeight: FontWeight.bold,
                                                                        // color: Color.fromARGB(255, 0, 0, 0),
                                                                        ),
                                                                  ),
                                                                  // controller: TextEditingController(
                                                                  //   text: _selectedToDateTime != null
                                                                  //       ? _selectedToDateTime.toString()
                                                                  //       : '',
                                                                  // ),
                                                                  controller:
                                                                      TextEditingController(
                                                                    text:
                                                                        "${month}",
                                                                  ),
                                                                ),
                                                              ),
                                                              // SizedBox(
                                                              //   width: 10,
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // ElevatedButton(
                                              //   style: ButtonStyle(
                                              //     backgroundColor:
                                              //         MaterialStateProperty.all<
                                              //                 Color>(
                                              //             const Color.fromARGB(
                                              //                 255,
                                              //                 251,
                                              //                 251,
                                              //                 251)), // Xoá nền
                                              //     shape: MaterialStateProperty.all<
                                              //         OutlinedBorder>(
                                              //       // Thêm border
                                              //       RoundedRectangleBorder(
                                              //         side: const BorderSide(
                                              //             color: Color.fromARGB(
                                              //                 255,
                                              //                 91,
                                              //                 91,
                                              //                 91)), // Màu và độ dày của border
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 8), // Độ cong của border
                                              //       ),
                                              //     ),
                                              //   ),
                                              //   child: Text(
                                              //     '${month}',
                                              //     style: const TextStyle(
                                              //       color: Colors.black,
                                              //     ),
                                              //   ),
                                              //   onPressed: () {
                                              //     _openDatePicker(context);
                                              //   },
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final barsSpace = 8.0 *
                                              constraints.maxWidth /
                                              1000000;
                                          double barsWidth = 0;
                                          if (isMonthSelected) {
                                            barsWidth = 8.0 *
                                                constraints.maxWidth /
                                                480;
                                          } else {
                                            barsWidth = 8.0 *
                                                constraints.maxWidth /
                                                200;
                                          }

                                          return BarChart(
                                            BarChartData(
                                              alignment:
                                                  BarChartAlignment.center,
                                              barTouchData: BarTouchData(
                                                enabled: false,
                                              ),
                                              titlesData: FlTitlesData(
                                                show: true,
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 28,
                                                    getTitlesWidget:
                                                        bottomTitles,
                                                  ),
                                                ),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 40,
                                                    getTitlesWidget: leftTitles,
                                                  ),
                                                ),
                                                topTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false),
                                                ),
                                                rightTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false),
                                                ),
                                              ),
                                              gridData: FlGridData(
                                                show: true,
                                                checkToShowHorizontalLine:
                                                    (value) => value % 5 == 0,
                                                getDrawingHorizontalLine:
                                                    (value) => FlLine(
                                                  color: Color(0xff3498DB),
                                                  strokeWidth: 1,
                                                ),
                                                drawVerticalLine: false,
                                              ),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              groupsSpace: barsSpace,
                                              barGroups:
                                                  getData(barsWidth, barsSpace),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Text("Report list: ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500))
              ]),
              SizedBox(
                height: 10,
              ),
              Center(
                child: DataTable(
                  decoration: BoxDecoration(),
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "${isMonthSelected ? "Day" : "Month"}",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Expectual',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Actual',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Unit',
                    //       style: TextStyle(fontStyle: FontStyle.italic),
                    //     ),
                    //   ),
                    // ),
                  ],
                  //
                  rows: buildDataRows(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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

  List<DataRow> buildDataRows() {
    // Khởi tạo danh sách DataRow
    List<DataRow> rows = [];

    // Duyệt qua mỗi dòng dữ liệu trong apiData và tạo DataRow tương ứng
    for (var data in listDiagramData) {
      // Tạo một list cells chứa các DataCell tương ứng với từng trường dữ liệu
      List<DataCell> cells = [];
      // data.actualMoney

      cells.add(DataCell(Text('${data.doM}')));
      cells.add(DataCell(Text('${data.expectMoney.toStringAsFixed(2)}')));
      cells.add(DataCell(Text('${data.actualMoney.toStringAsFixed(2)}')));
      // Duyệt qua mỗi trường dữ liệu trong dòng hiện tại và thêm vào cells
      // data.forEach((key, value) {
      //   cells.add(DataCell(Text('$value')));
      // });

      // Thêm DataRow mới vào danh sách rows
      rows.add(DataRow(cells: cells));
    }

    return rows;
  }

  List<BarChartGroupData> getData(double barWidth, double barsSpace) {
    List<BarChartGroupData> data = [];

    for (int i = 0; i < listDiagramData.length; i++) {
      data.add(
        BarChartGroupData(
          x: listDiagramData[i].doM,
          barRods: [
            BarChartRodData(
              toY: listDiagramData[i].expectMoney.toDouble(),
              width: barWidth,
              color: Colors.green,
              borderRadius: BorderRadius.zero,
            ),
            BarChartRodData(
              toY: listDiagramData[i].actualMoney.toDouble(),
              width: barWidth,
              color: Color.fromARGB(255, 248, 213, 87),
              borderRadius: BorderRadius.zero,
            ),
          ],
          barsSpace: barsSpace,
        ),
      );
    }

    return data;
  }

  // List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
  //   return [
  //     BarChartGroupData(
  //       x: 0,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 17000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 2000000000, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //     BarChartGroupData(
  //       x: 1,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 31000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 11000000000, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //         BarChartRodData(
  //           toY: 31000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 11000000000, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //     BarChartGroupData(
  //       x: 2,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 34000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 6000000000, Colors.black),
  //             BarChartRodStackItem(0, 6000000000, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //         BarChartRodData(
  //           toY: 34000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 6000000000, Colors.black),
  //             BarChartRodStackItem(0, 6000000000, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //     BarChartGroupData(
  //       x: 3,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 14000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 1000000000.5, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //     BarChartGroupData(
  //       x: 4,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 14000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 1000000000.5, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //     BarChartGroupData(
  //       x: 5,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 14000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 1000000000.5, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //     BarChartGroupData(
  //       x: 6,
  //       barsSpace: barsSpace,
  //       barRods: [
  //         BarChartRodData(
  //           toY: 14000000000,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 1000000000.5, Colors.black),
  //           ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),
  //   ];
  // }
}
