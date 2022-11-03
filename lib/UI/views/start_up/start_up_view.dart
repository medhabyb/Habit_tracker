import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/UI/views/start_up/widget/habits.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:stacked/stacked.dart';

import './start_up_view_model.dart';

class StartUpView extends StatefulWidget {
  @override
  State<StartUpView> createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
        viewModelBuilder: () => StartUpViewModel(),
        onModelReady: (StartUpViewModel model) async {
          await model.init();
        },
        builder: (
          BuildContext context,
          StartUpViewModel model,
          Widget? child,
        ) {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              title: Text('Consistency is key.'),
            ),
            body: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (model.habitList.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: model.habitList.length,
                        itemBuilder: ((context, index) => Habit(
                              habitName: model.habitList[index].name,
                              onTap: (() {
                                model.habitstared(index);
                              }),
                              settingsTapped: (() async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        title: Text("Settings for " +
                                            model.habitList[index].name),
                                      );
                                    });
                                ;
                                // await model.DeleteHabit(index);
                              }),
                              habitStarted: model.inttobool(index),
                              timeSpent: model.habitList[index].spent,
                              delete: (() => model.DeleteHabit(index)),
                              formatMinSec: model
                                  .formatMinSec(model.habitList[index].spent),
                              timeGoal: model.habitList[index].goal,
                              isDone: model.isDone,
                            )))
                    : const Center(
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
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
                                controller: model.textFieldController,
                                decoration: const InputDecoration(
                                    hintText: "Text Field in Dialog"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              NumberPicker(
                                value: model.values,
                                minValue: 1,
                                maxValue: 60,
                                step: 1,
                                //haptics: true,
                                onChanged: (value) =>
                                    setState(() => model.values = value),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: model.raisedButtonStyle,
                                onPressed: () {
                                  model.addhabit(model.textFieldController.text,
                                      model.values);
                                  Navigator.pop(context);
                                },
                                child: const Text('Add Habit'),
                              )
                            ]),
                          ),
                        );
                      });
                    }),
              },
              backgroundColor: Colors.grey[900],
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
