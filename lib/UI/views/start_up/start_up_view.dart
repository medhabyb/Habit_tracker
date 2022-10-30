import 'package:flutter/material.dart';
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
                              HabitName: model.habitList[index].id.toString(),
                              onTap: (() {
                                model.habitstared(index);
                              }),
                              settingsTapped: (() async {
                                //model.settingsOpened(index, context);
                                await model.DeleteDog(index);
                              }),
                              habitStarted: model.inttobool(index),
                              timeSpent: model.habitList[index].spent,
                              timeGoal: model.habitList[index].goal,
                            )))
                    : const Center(
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                model.addOpened(context),
              },
              backgroundColor: Colors.grey[900],
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}