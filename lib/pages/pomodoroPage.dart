<<<<<<< HEAD

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ssps_app/models/pomodoro_status.dart';
import 'package:ssps_app/utils/constants.dart';
import 'package:ssps_app/widget/progress_icons.dart';
import 'package:ssps_app/widget/custom_button.dart';
import 'package:audioplayers/audioplayers.dart';
=======
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/models/pomodoro_status.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/pages/messagePage.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/utils/constants.dart';
import 'package:ssps_app/widget/drawer_widget.dart';
import 'package:ssps_app/widget/progress_icons.dart';
import 'package:ssps_app/widget/custom_button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ssps_app/components/notification/local_notification.dart';
>>>>>>> dev

class PomodoroPage extends StatefulWidget {
  PomodoroPage({Key? key}) : super(key: key);

  @override
  State<PomodoroPage> createState() => _PomodoroPage();
}

<<<<<<< HEAD
const _btnTexStart  = "START POMODORO";
=======
const _btnTextStart = "START POMODORO";
>>>>>>> dev
const _btnTextResumePomodoro = "RESUME POMODORO";
const _btnTextResumeBreak = "RESUME BREAK";
const _btnTextStartShortBreak = "TAKE SHORT BREAK";
const _btnTextStartLongBreak = "TAKE LONG BREAK";
const _btnTextStartNewSet = "START NEW SET";
const _btnTextPause = "PAUSE";
const _btnTextReset = "RESET";
<<<<<<< HEAD

class _PomodoroPage extends State<PomodoroPage> {
  
  final player = AudioPlayer();
  int remainningTime = pomodoroTotalTime;
  String mainBtnText = _btnTexStart;
=======
const _btnTextSetting = "SETTING";

class _PomodoroPage extends State<PomodoroPage> {
  final player = AudioPlayer();
  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
>>>>>>> dev
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausePomodoro;
  Timer _timer = Timer(Duration(milliseconds: 1), () {});
  int pomodoroNum = 0;
  int setNum = 0;
<<<<<<< HEAD
=======
  String? firstName;
  String? lastName;
  bool isDataLoaded = false;
  int pomodoroTimeInMinutes = 25;
  int shortBreakTimeInMinutes = 5;
  int longBreakTimeInMinutes = 15;
  List<String> todoList = [];
  TextEditingController _todoController = TextEditingController();
  List<bool> taskCompleted = [];
>>>>>>> dev

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
=======
    _decodeToken();
  }

  _decodeToken() async {
    var token = await SharedService.loginDetails();
    String? accessToken = token?.data?.accessToken;
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

  _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Pomodoro Times'),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Pomodoro Time (minutes)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      pomodoroTimeInMinutes = int.tryParse(value) ?? 25;
                    });
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Short Break Time (minutes)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      shortBreakTimeInMinutes = int.tryParse(value) ?? 5;
                    });
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Long Break Time (minutes)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      longBreakTimeInMinutes = int.tryParse(value) ?? 15;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pomodoroTotalTime = pomodoroTimeInMinutes * 60;
                  shortBreakTime = shortBreakTimeInMinutes * 60;
                  longBreakTime = longBreakTimeInMinutes * 60;
                });
                _resetButtonPressed();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
>>>>>>> dev
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: Color(0xff2E4DF2),
        elevation: 0,
        centerTitle: true,
        title: const Text("Pomodoro"),
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {
        }, icon: const Icon(Icons.person))],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pomodoro number: ${pomodoroNum}", style: TextStyle(fontSize: 20, color: Colors.black),),
                  Text("Set: ${setNum}", style: TextStyle(fontSize: 20, color: Colors.black),),
                ],
              ),
            ),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 150.0,
                    lineWidth: 15.0,
                    percent: _getPomodoroPercentage(),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(_secondsToFormatedString(remainningTime), style: TextStyle(fontSize: 40, color: statusColor[pomodoroStatus])),
                    progressColor: Colors.red,
                  ),
                  SizedBox(height: 10,),
                  ProgressIcons(total: pomodoroPerSet, done: pomodoroNum - (setNum * pomodoroPerSet),),
                  SizedBox(height: 10),
                  Text(
                    statusDescription[pomodoroStatus]!,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    onTap: _mainButtonPressed,
                    text: mainBtnText,

                  ),
                  CustomButton(
                    onTap: _resetButtonPressed,
                    text: _btnTextReset,

                  ),
                ],
              )
            ),
          ],
=======
        backgroundColor: Color(0xff3498DB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pomodoro",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: isDataLoaded
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
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    },
                  )
                : SizedBox(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pomodoro number: $pomodoroNum",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    "Set: $setNum",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 15),
              CircularPercentIndicator(
                radius: 150.0,
                lineWidth: 15.0,
                percent: _getPomodoroPercentage(),
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  _secondsToFormattedString(remainingTime),
                  style: TextStyle(
                      fontSize: 40, color: statusColor[pomodoroStatus]),
                ),
                progressColor: Colors.red,
              ),
              SizedBox(height: 10),
              ProgressIcons(
                total: pomodoroPerSet,
                done: pomodoroNum - (setNum * pomodoroPerSet),
              ),
              SizedBox(height: 10),
              Text(
                statusDescription[pomodoroStatus]!,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              CustomButton(
                onTap: _mainButtonPressed,
                text: mainBtnText,
              ),
              // SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: _resetButtonPressed,
                    text: _btnTextReset,
                  ),
                  SizedBox(width: 10),
                  CustomButton(
                    onTap: _showSettingsDialog,
                    text: _btnTextSetting,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Todo List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _todoController,
                decoration: InputDecoration(
                  labelText: 'Add a new task',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addTodo();
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: taskCompleted[index],
                      onChanged: (bool? value) {
                        setState(() {
                          taskCompleted[index] = value!;
                        });
                      },
                    ),
                    title: Text(
                      todoList[index],
                      style: TextStyle(
                        decoration: taskCompleted[index]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "Chat",
      //   backgroundColor: const Color.fromARGB(255, 57, 161, 247),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => MessengerPage()),
      //     );
      //   },
      //   child: const Icon(
      //     Icons.chat,
      //     color: Colors.white,
      //   ),
      // ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(context),
              ],
            ),
          ),
>>>>>>> dev
        ),
      ),
    );
  }

<<<<<<< HEAD
  _secondsToFormatedString(int seconds) {
    int roundedMinutes  = seconds ~/ 60;
    int remainningSeconds = seconds - (roundedMinutes *60);
    String remainingSecondsFormated;

   if(remainningSeconds  < 10) {
    remainingSecondsFormated = '0$remainningSeconds';
   } else {
    remainingSecondsFormated = remainningSeconds.toString();
   }

   return '$roundedMinutes:$remainingSecondsFormated';
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch(pomodoroStatus) {
=======
  void _addTodo() {
    String newTodo = _todoController.text.trim();
    if (newTodo.isNotEmpty) {
      setState(() {
        todoList.add(newTodo);
        taskCompleted.add(false); // Thêm trạng thái hoàn thành mới
        _todoController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
      taskCompleted.removeAt(index); // Xoá trạng thái hoàn thành tương ứng
    });
  }

  String _secondsToFormattedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormatted;

    if (remainingSeconds < 10) {
      remainingSecondsFormatted = '0$remainingSeconds';
    } else {
      remainingSecondsFormatted = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormatted';
  }

  double _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
>>>>>>> dev
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausePomodoro:
<<<<<<< HEAD
        // TODO: Handle this case.
        totalTime = pomodoroTotalTime; 
        break;
      case PomodoroStatus.runningShortBreak:
        // TODO: Handle this case.
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pauseShortBreak:
        // TODO: Handle this case.
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        // TODO: Handle this case.
        break;
      case PomodoroStatus.pauseLongBreak:
        totalTime = longBreakTime;
        // TODO: Handle this case.
        break;
      case PomodoroStatus.setFinished:
        // TODO: Handle this case.
        totalTime = pomodoroTotalTime;
        break;
    }
    double percentage = (totalTime - remainningTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() {
    switch(pomodoroStatus) {
      case PomodoroStatus.pausePomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
        // TODO: Handle this case.
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
        // TODO: Handle this case.
      case PomodoroStatus.pauseShortBreak:
        _startShortBreak();
        break;
        // TODO: Handle this case.
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
        // TODO: Handle this case.
      case PomodoroStatus.pauseLongBreak:
        _startLongBreak();
        break;
        // TODO: Handle this case.
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
        // TODO: Handle this case.

    }
  }
  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => { 
      if(remainningTime > 0) {
        setState(() {
          remainningTime--;
          mainBtnText = _btnTextPause;
        }),
      } else {
        _playSound(),
        pomodoroNum ++,
        _cancelTimer(),
        if(pomodoroNum % pomodoroPerSet == 0) {
          pomodoroStatus = PomodoroStatus.pauseLongBreak,
          setState(() {
            remainningTime = longBreakTime;
            mainBtnText = _btnTextStartLongBreak;
          })
        }else {
          pomodoroStatus = PomodoroStatus.pauseShortBreak,
          setState(() {
            remainningTime = shortBreakTime;
            mainBtnText = _btnTextStartShortBreak;
          })
        }
      }
     });
  }

  _startShortBreak() {
=======
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
      case PomodoroStatus.pauseShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
      case PomodoroStatus.pauseLongBreak:
        totalTime = longBreakTime;
        break;
    }
    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  void _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausePomodoro:
      case PomodoroStatus.setFinished:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
      case PomodoroStatus.runningShortBreak:
      case PomodoroStatus.runningLongBreak:
        _pauseCountdown();
        break;
      case PomodoroStatus.pauseShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.pauseLongBreak:
        _startLongBreak();
        break;
    }
  }

  void _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
          mainBtnText = _btnTextPause;
        });
      } else {
        _playSound();
        LocalNotifications.showSimpleNotification(
            title: "SSPS", body: "Pomodoro: time is up!", payload: "Pomodoro");
        pomodoroNum++;
        _cancelTimer();
        if (pomodoroNum % pomodoroPerSet == 0) {
          pomodoroStatus = PomodoroStatus.pauseLongBreak;
          setState(() {
            remainingTime = longBreakTime;
            mainBtnText = _btnTextStartLongBreak;
          });
        } else {
          pomodoroStatus = PomodoroStatus.pauseShortBreak;
          setState(() {
            remainingTime = shortBreakTime;
            mainBtnText = _btnTextStartShortBreak;
          });
        }
      }
    });
  }

  void _startShortBreak() {
>>>>>>> dev
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
<<<<<<< HEAD
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      if(remainningTime > 0) {
        setState(() {
          remainningTime --;
        });
      }else {
        //play sound
        _playSound(); 
        remainningTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.pausePomodoro;
        setState(() {
          mainBtnText = _btnTexStart;
        });
      }
     });
  }

  _startLongBreak() {
=======
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _playSound();
        LocalNotifications.showSimpleNotification(
            title: "SSPS", body: "Pomodoro: time is up!", payload: "Pomodoro");
        remainingTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.pausePomodoro;
        setState(() {
          mainBtnText = _btnTextStart;
        });
      }
    });
  }

  void _startLongBreak() {
>>>>>>> dev
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
<<<<<<< HEAD
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      if(remainningTime > 0) {
        setState(() {
          remainningTime --;
        });
      }else {
        //play sound
        _playSound(); 
        remainningTime = pomodoroTotalTime;
=======
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _playSound();
        LocalNotifications.showSimpleNotification(
            title: "SSPS", body: "Pomodoro: time is up!", payload: "Pomodoro");
        remainingTime = pomodoroTotalTime;
>>>>>>> dev
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.setFinished;
        setState(() {
          mainBtnText = _btnTextStartNewSet;
        });
      }
<<<<<<< HEAD
     });
  }

  _pausePomodoroCountdown() {
=======
    });
  }

  void _pauseCountdown() {
>>>>>>> dev
    pomodoroStatus = PomodoroStatus.pausePomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

<<<<<<< HEAD
  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pauseShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pauseLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });
  }

  _resetButtonPressed() {
=======
  void _resetButtonPressed() {
>>>>>>> dev
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

<<<<<<< HEAD
  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausePomodoro;
    setState(() {
      mainBtnText = _btnTexStart;
      remainningTime = pomodoroTotalTime;
    });
  }

  _cancelTimer() {
    if(_timer != null  && _timer.isActive) {
=======
  void _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausePomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  void _cancelTimer() {
    if (_timer.isActive) {
>>>>>>> dev
      _timer.cancel();
    }
  }

<<<<<<< HEAD
  _playSound() async {
    // await audioPlayer.play(UrlSource('audio.mp3'));\
    String audioPath = "audio/audio.mp3";
    await player.play(AssetSource(audioPath));
  }
}
=======
  void _playSound() async {
    String audioPath = "audio/audio.mp3";
    await player.play(AssetSource(audioPath));
  }
}
>>>>>>> dev
