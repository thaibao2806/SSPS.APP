import 'package:flutter/material.dart';
import 'package:ssps_app/models/pomodoro_status.dart';

var pomodoroTotalTime = 25*60 ;
var shortBreakTime = 5*60;
var longBreakTime = 15*60;
const pomodoroPerSet = 4;

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro:"Pomodoro is running, time to be forcused",
  PomodoroStatus.pausePomodoro:"Ready for a focused pomodoro?",
  PomodoroStatus.runningShortBreak:"Short break is running, time to relax",
  PomodoroStatus.pauseShortBreak:"Let\'s have a short break?",
  PomodoroStatus.runningLongBreak:"Long break is running, time to relax",
  PomodoroStatus.pauseLongBreak:"Let\'s have a short break?",
  PomodoroStatus.setFinished:"Congrats, you deserve a long break, ready to start?",
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausePomodoro:Colors.orange,
  PomodoroStatus.runningShortBreak:Colors.red,
  PomodoroStatus.pauseShortBreak:Colors.orange,
  PomodoroStatus.runningLongBreak:Colors.red,
  PomodoroStatus.pauseLongBreak:Colors.orange,
  PomodoroStatus.setFinished:Colors.orange,
};