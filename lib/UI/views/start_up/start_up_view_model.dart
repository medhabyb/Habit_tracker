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

  Future<void> init() async {
    setBusy(true);
    _dbb = Db();

    habit = Habits(name: 'jogging', spent: 0, goal: 10, started: 0);
    _habitlist = await getHabits();

    // ignore: unnecessary_null_comparison
    if (_dbb != null) {
      setBusy(false);
    }
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
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_habitlist[index].started == 0) {
          timer.cancel();
          updateDog(index);
        }

        var currenttime = DateTime.now();
        _habitlist[index].spent = elapsedtime +
            currenttime.second -
            startTime.second +
            60 * (currenttime.minute - startTime.minute);
      });
    }
    notifyListeners();
  }

  void addhabit(String habit, int period) {
    _habitlist.add([habit, false, 0, period]);
    _textFieldController.clear();
    _values = 1;
    notifyListeners();
  }

  void settingsOpened(int index, context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // ignore: prefer_interpolation_to_compose_strings
            title: Text("Settings for " + _habitlist[index].name),
          );
        });
    notifyListeners();
  }

  void addOpened(context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Habit'),
              content: Container(
                height: 400,
                width: 150,
                child: Column(children: [
                  TextField(
                    onChanged: (value) {},
                    controller: _textFieldController,
                    decoration:
                        const InputDecoration(hintText: "Text Field in Dialog"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NumberPicker(
                    value: _values,
                    minValue: 1,
                    maxValue: 60,
                    step: 1,
                    //haptics: true,
                    onChanged: (value) => setState(() => _values = value),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () {
                      addhabit(_textFieldController.text, _values);
                      Navigator.pop(context);
                    },
                    child: const Text('Add Habit'),
                  )
                ]),
              ),
            );
          });
        });

    notifyListeners();
  }

  Future<List<Habits>> getHabits() async {
    Database db = await _dbb.database;

    var habits = await db.query(('Test'));
    List<Habits> habitslits =
        habits.isNotEmpty ? habits.map((e) => Habits.fromMap(e)).toList() : [];
    return habitslits;
  }

  Future<void> insertDog(Habits dog) async {
    final db = await _dbb.database;

    await db.insert(
      'Test',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDog(int index) async {
    final db = await _dbb.database;

    await db.rawUpdate('UPDATE Test SET spent = ? WHERE id = ?',
        [_habitlist[index].spent, _habitlist[index].id]);
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<void> DeleteDog(int index) async {
    final db = await _dbb.database;

    await db.rawDelete('DELETE FROM Test WHERE id = ?', [_habitlist[index].id]);
    notifyListeners();
  }

  bool inttobool(int index) {
    if (_habitlist[index].started == 0) {
      return false;
    } else {
      return true;
    }
  }
}
