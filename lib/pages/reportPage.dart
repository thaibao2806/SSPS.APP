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
      case 5:
        text = 'Aug';
        break;
      case 6:
        text = 'Aug';
        break;
      case 7:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
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
                            SizedBox(
                              width: 30,
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
                                              color: Color.fromARGB(255, 81, 212, 85)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "1000000 VND",
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
                              width: 30,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(
                                "Total actual",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 248, 213, 87)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "10000 VND",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w500),
                              ),
                            ])
                            // Text(
                            //   "Total actual",
                            //   style: TextStyle(
                            //       fontSize: 18,
                            //       color: Color.fromARGB(255, 81, 212, 85)),
                            // ),
                            // SizedBox(height: 10,),
                            // Text(
                            //   "10000 VND",
                            //   style: TextStyle(
                            //     fontSize: 25,
                            //     fontWeight: FontWeight.w500
                            //   ),
                            // ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total spending:",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "10000\$",
                                            style: TextStyle(fontSize: 20),
                                          ),
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
                                              5.0 * constraints.maxWidth / 80;
                                          final barsWidth =
                                              8.0 * constraints.maxWidth / 100;
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
                                                    (value) => value % 10 == 0,
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
                height: 10,
              ),
              Row(children: [
                Text("Categories list: ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500))
              ]),
              SizedBox(
                height: 10,
              ),
              Center(
                child: DataTable(
                  decoration: BoxDecoration(
                    
                  ),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Category',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Title',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Money',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                     DataColumn(
                      label: Expanded(
                        child: Text(
                          'Unit',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Sarah')),
                        DataCell(Text('19')),
                        DataCell(Text('Student')),
                        DataCell(Text('vnd')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Janine')),
                        DataCell(Text('43')),
                        DataCell(Text('Professor')),
                        DataCell(Text('vnd')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('vnd')),
                      ],
                    ),
                  ],
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
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Colors.black),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Colors.black),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Colors.black),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}
