import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/models/pomodoro_status.dart';
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/utils/constants.dart';
import 'package:ssps_app/widget/drawer_widget.dart';
import 'package:ssps_app/widget/progress_icons.dart';
import 'package:ssps_app/widget/custom_button.dart';
import 'package:audioplayers/audioplayers.dart';

class PomodoroPage extends StatefulWidget {
  PomodoroPage({Key? key}) : super(key: key);

  @override
  State<PomodoroPage> createState() => _PomodoroPage();
}

const _btnTexStart = "START POMODORO";
const _btnTextResumePomodoro = "RESUME POMODORO";
const _btnTextResumeBreak = "RESUME BREAK";
const _btnTextStartShortBreak = "TAKE SHORT BREAK";
const _btnTextStartLongBreak = "TAKE LONG BREAK";
const _btnTextStartNewSet = "START NEW SET";
const _btnTextPause = "PAUSE";
const _btnTextReset = "RESET";

class _PomodoroPage extends State<PomodoroPage> {
  final player = AudioPlayer();
  int remainningTime = pomodoroTotalTime;
  String mainBtnText = _btnTexStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausePomodoro;
  Timer _timer = Timer(Duration(milliseconds: 1), () {});
  int pomodoroNum = 0;
  int setNum = 0;
  String? firstName;
  String? lastName;
  bool isDataLoaded = false;

  @override
  void dispose() {
    _cancelTimer();
    _decodeToken();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
        title: const Text("Pomodoro", style: TextStyle(color: Colors.white),),
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
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pomodoro number: ${pomodoroNum}",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    "Set: ${setNum}",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
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
                  center: Text(_secondsToFormatedString(remainningTime),
                      style: TextStyle(
                          fontSize: 40, color: statusColor[pomodoroStatus])),
                  progressColor: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
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
                CustomButton(
                  onTap: _resetButtonPressed,
                  text: _btnTextReset,
                ),
              ],
            )),
          ],
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

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainningSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainningSeconds < 10) {
      remainingSecondsFormated = '0$remainningSeconds';
    } else {
      remainingSecondsFormated = remainningSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausePomodoro:
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
    switch (pomodoroStatus) {
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

    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
              if (remainningTime > 0)
                {
                  setState(() {
                    remainningTime--;
                    mainBtnText = _btnTextPause;
                  }),
                }
              else
                {
                  _playSound(),
                  pomodoroNum++,
                  _cancelTimer(),
                  if (pomodoroNum % pomodoroPerSet == 0)
                    {
                      pomodoroStatus = PomodoroStatus.pauseLongBreak,
                      setState(() {
                        remainningTime = longBreakTime;
                        mainBtnText = _btnTextStartLongBreak;
                      })
                    }
                  else
                    {
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
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainningTime > 0) {
        setState(() {
          remainningTime--;
        });
      } else {
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
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainningTime > 0) {
        setState(() {
          remainningTime--;
        });
      } else {
        //play sound
        _playSound();
        remainningTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.setFinished;
        setState(() {
          mainBtnText = _btnTextStartNewSet;
        });
      }
    });
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausePomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

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
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausePomodoro;
    setState(() {
      mainBtnText = _btnTexStart;
      remainningTime = pomodoroTotalTime;
    });
  }

  _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  _playSound() async {
    // await audioPlayer.play(UrlSource('audio.mp3'));\
    String audioPath = "audio/audio.mp3";
    await player.play(AssetSource(audioPath));
  }
}
