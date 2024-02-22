
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ssps_app/models/pomodoro_status.dart';
import 'package:ssps_app/utils/constants.dart';
import 'package:ssps_app/widget/progress_icons.dart';
import 'package:ssps_app/widget/custom_button.dart';
import 'package:audioplayers/audioplayers.dart';

class PomodoroPage extends StatefulWidget {
  PomodoroPage({Key? key}) : super(key: key);

  @override
  State<PomodoroPage> createState() => _PomodoroPage();
}

const _btnTexStart  = "START POMODORO";
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

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        ),
      ),
    );
  }

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
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
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
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
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
    if(_timer != null  && _timer.isActive) {
      _timer.cancel();
    }
  }

  _playSound() async {
    // await audioPlayer.play(UrlSource('audio.mp3'));\
    String audioPath = "audio/audio.mp3";
    await player.play(AssetSource(audioPath));
  }
}