import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:habit_tracker/UI/views/start_up/widget/habits.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';

import '../../../Services/Class/db.dart';
import '../../../Services/Class/habits.dart';

class StartUpViewModel extends BaseViewModel {
  List _habitlist = [];

  List get habitList => _habitlist;

  late Db _dbb;

  Db get dbb => _dbb;

  bool _isDone = false;

  bool get isDone => _isDone;

  //Future<Database> get database async => _database ??= await _initDatabase();
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  final _textFieldController = TextEditingController();

  TextEditingController get textFieldController => _textFieldController;
  int _values = 1;
  Habits? habit;
  int get values => _values;
  set values(int) => _values;

  Future<void> init() async {
    setBusy(true);
    _dbb = Db();

    habit = Habits(name: 'jogging', spent: 0, goal: 10, started: 0);
    _habitlist = await getHabits();

    // ignore: unnecessary_null_comparison
    if (_dbb != null) {
      setBusy(false);
    }
    notifyListeners();
  }

  void habitstared(int index) async {
    var startTime = DateTime.now();
    int elapsedtime = _habitlist[index].spent;

    if (_habitlist[index].started == 0) {
      _habitlist[index].started = 1;
    } else if (_habitlist[index].started == 1) {
      _habitlist[index].started = 0;
    }

    if (_habitlist[index].started == 1) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (_habitlist[index].started == 0) {
          timer.cancel();
          updateHabit(index);
          //notifyListeners();
        } else if (_habitlist[index].spent == (_habitlist[index].goal * 60)) {
          timer.cancel();
          updateHabit(index);
          _isDone = true;
        }

        var currenttime = DateTime.now();
        _habitlist[index].spent = elapsedtime +
            currenttime.second -
            startTime.second +
            60 * (currenttime.minute - startTime.minute);
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void addhabit(String name, int period) async {
    final db = await _dbb.database;
    habit = Habits(name: name, spent: 0, goal: period, started: 0);
    await db.insert(
      'Test',
      habit!.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _habitlist = await getHabits();
    //_habitlist.add([habit, false, 0, period]);
    _textFieldController.clear();
    _values = 1;
    notifyListeners();
  }

  void settingsOpened(int index, context) {
    notifyListeners();
  }

  void addOpened(context) {
    notifyListeners();
  }

  Future<List<Habits>> getHabits() async {
    Database db = await _dbb.database;

    var habits = await db.query(('Test'));
    List<Habits> habitslits =
        habits.isNotEmpty ? habits.map((e) => Habits.fromMap(e)).toList() : [];
    notifyListeners();
    return habitslits;
  }

  Future<void> insertHabit(Habits Habit) async {
    final db = await _dbb.database;

    await db.insert(
      'Test',
      Habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _habitlist = await getHabits();
  }

  Future<void> updateHabit(int index) async {
    final db = await _dbb.database;

    await db.rawUpdate('UPDATE Test SET spent = ? WHERE id = ?',
        [_habitlist[index].spent, _habitlist[index].id]);
    _habitlist = await getHabits();
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<void> DeleteHabit(int index) async {
    final db = await _dbb.database;

    await db.rawDelete('DELETE FROM Test WHERE id = ?', [_habitlist[index].id]);
    _habitlist = await getHabits();
    notifyListeners();
  }

  bool inttobool(int index) {
    if (_habitlist[index].started == 0) {
      return false;
    } else {
      return true;
    }
  }

  String formatMinSec(int tsecs) {
    String secs = (tsecs % 60).toString();
    String mins = (tsecs / 60).toStringAsFixed(5);

    if (mins[1] == ".") {
      mins = mins.substring(0, 1);
    }

    if (secs.length == 1) {
      secs = '0' + secs;
    }
    return mins + ":" + secs;
  }
}
