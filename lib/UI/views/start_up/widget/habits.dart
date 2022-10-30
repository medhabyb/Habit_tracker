import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Habit extends StatelessWidget {
  final String? HabitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int? timeSpent;
  final int? timeGoal;
  final bool habitStarted;

  const Habit(
      {super.key,
      required this.HabitName,
      required this.onTap,
      required this.settingsTapped,
      required this.timeSpent,
      required this.timeGoal,
      required this.habitStarted});

// ignore: non_constant_identifier_names
  double PercentCompleted() {
    return timeSpent! / (timeGoal! * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[200],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      CircularPercentIndicator(
                        radius: 60,
                        percent: PercentCompleted(),
                        progressColor: PercentCompleted() > 0.5
                            ? (PercentCompleted() > 0.75
                                ? Colors.green
                                : Colors.orange)
                            : Colors.red,
                      ),
                      Center(
                        child: Icon(habitStarted == true
                            ? Icons.pause
                            : Icons.play_arrow),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //progress circle

                //habit name
                Text(
                  "$HabitName",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 4),

                //progress
                Text(
                  formatMinSec(timeSpent!) +
                      '/' +
                      timeGoal.toString() +
                      ' = ' +
                      (PercentCompleted() * 100).toStringAsFixed(0) +
                      '%',
                  style: TextStyle(color: Colors.grey),
                ),
              ]),
            ],
          ),
          GestureDetector(onTap: settingsTapped, child: Icon(Icons.settings)),
        ]),
      ),
    );
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
