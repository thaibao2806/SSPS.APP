import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/widget/drawer_widget.dart';

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

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Apr';
        break;
      case 1:
        text = 'May';
        break;
      case 2:
        text = 'Jun';
        break;
      case 3:
        text = 'Jul';
        break;
      case 4:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3498DB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Report",
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
      body: Stack(
        children: [
          Container(
            // height: double.infinity,
            // width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffA1F0FB), Color(0xffA1F0FB)]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 30),
              child: Container(
                height: 300, // Đặt chiều cao tùy ý tại đây
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Total spending:"),
                                    Text("10000\$"),
                                  ],
                                ),
                                DropdownButton<String>(
                                  items: <String>['Day', 'Week', 'Month']
                                      .map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    // Xử lý giá trị được chọn
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  },
                                  // hint: Text('Chọn một tùy chọn'),
                                  value: selectedValue,
                                  // dropdownColor: Colors.grey,
                                ),
                              ],
                            ),
                            AspectRatio(
                              aspectRatio: 1.6,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final barsSpace =
                                        5.0 * constraints.maxWidth / 400;
                                    final barsWidth =
                                        8.0 * constraints.maxWidth / 400;
                                    return BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.center,
                                        barTouchData: BarTouchData(
                                          enabled: false,
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 28,
                                              getTitlesWidget: bottomTitles,
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
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          show: true,
                                          checkToShowHorizontalLine: (value) =>
                                              value % 10 == 0,
                                          getDrawingHorizontalLine: (value) =>
                                              FlLine(
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
          Padding(
            padding: const EdgeInsets.only(top: 310.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                child: SingleChildScrollView(
                  reverse: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 100,
                              width: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Total expect",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 81, 212, 85)),
                                ),
                              )),
                          Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(138, 105, 104, 104),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              height: 100,
                              width: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Total actual",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 81, 212, 85))),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transaction list",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          DropdownButton<String>(
                            items: <String>['Day', 'Week', 'Month']
                                .map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            focusColor: Color.fromARGB(255, 71, 218, 228),
                            iconEnabledColor: Color.fromARGB(255, 71, 218, 228),
                            iconDisabledColor:
                                Color.fromARGB(255, 71, 218, 228),
                            borderRadius: BorderRadius.circular(10),
                            onChanged: (String? value) {
                              // Xử lý giá trị được chọn
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            // hint: Text('Chọn một tùy chọn'),
                            value: selectedValue,
                            // dropdownColor: Colors.grey,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text("Task")],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
              heroTag: "Chat",
              backgroundColor: const Color.fromARGB(255, 57, 161, 247),
              onPressed: () {
                Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>  MessengerPage()));
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

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000, Colors.black),
              BarChartRodStackItem(2000000000, 12000000000, Colors.blue),
              BarChartRodStackItem(12000000000, 17000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 13000000000, Colors.black),
              BarChartRodStackItem(13000000000, 14000000000, Colors.blue),
              BarChartRodStackItem(14000000000, 24000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 23000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, Colors.black),
              BarChartRodStackItem(6000000000.5, 18000000000, Colors.blue),
              BarChartRodStackItem(18000000000, 23000000000.5, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, Colors.black),
              BarChartRodStackItem(9000000000, 15000000000, Colors.blue),
              BarChartRodStackItem(15000000000, 29000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000.5, Colors.black),
              BarChartRodStackItem(2000000000.5, 17000000000.5, Colors.blue),
              BarChartRodStackItem(17000000000.5, 32000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 11000000000, Colors.black),
              BarChartRodStackItem(11000000000, 18000000000, Colors.blue),
              BarChartRodStackItem(18000000000, 31000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 35000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 14000000000, Colors.black),
              BarChartRodStackItem(14000000000, 27000000000, Colors.blue),
              BarChartRodStackItem(27000000000, 35000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 8000000000, Colors.black),
              BarChartRodStackItem(8000000000, 24000000000, Colors.blue),
              BarChartRodStackItem(24000000000, 31000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, Colors.black),
              BarChartRodStackItem(6000000000.5, 12000000000.5, Colors.blue),
              BarChartRodStackItem(12000000000.5, 15000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, Colors.black),
              BarChartRodStackItem(9000000000, 15000000000, Colors.blue),
              BarChartRodStackItem(15000000000, 17000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 34000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, Colors.black),
              BarChartRodStackItem(6000000000, 23000000000, Colors.blue),
              BarChartRodStackItem(23000000000, 34000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, Colors.black),
              BarChartRodStackItem(7000000000, 24000000000, Colors.blue),
              BarChartRodStackItem(24000000000, 32000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 14000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Colors.black),
              BarChartRodStackItem(1000000000.5, 12000000000, Colors.blue),
              BarChartRodStackItem(12000000000, 14000000000.5, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 20000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, Colors.black),
              BarChartRodStackItem(4000000000, 15000000000, Colors.blue),
              BarChartRodStackItem(15000000000, 20000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, Colors.black),
              BarChartRodStackItem(4000000000, 15000000000, Colors.blue),
              BarChartRodStackItem(15000000000, 24000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Colors.black),
              BarChartRodStackItem(1000000000.5, 12000000000, Colors.blue),
              BarChartRodStackItem(12000000000, 14000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 27000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, Colors.black),
              BarChartRodStackItem(7000000000, 25000000000, Colors.blue),
              BarChartRodStackItem(25000000000, 27000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, Colors.black),
              BarChartRodStackItem(6000000000, 23000000000, Colors.blue),
              BarChartRodStackItem(23000000000, 29000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 16000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, Colors.black),
              BarChartRodStackItem(9000000000, 15000000000, Colors.blue),
              BarChartRodStackItem(15000000000, 16000000000.5, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, Colors.black),
              BarChartRodStackItem(7000000000, 12000000000.5, Colors.blue),
              BarChartRodStackItem(12000000000.5, 15000000000, Colors.green),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}
