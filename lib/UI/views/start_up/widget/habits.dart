import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

//typedef IntCallback = String Function(int sec);

class Habit extends StatelessWidget {
  final String? habitName;
  final VoidCallback onTap;
  final AsyncCallback delete;
  final String formatMinSec;
  final VoidCallback settingsTapped;
  final int? timeSpent;
  final int? timeGoal;
  final bool habitStarted;
  final bool isDone;

  const Habit(
      {super.key,
      required this.habitName,
      required this.onTap,
      required this.settingsTapped,
      required this.timeSpent,
      required this.delete,
      required this.formatMinSec,
      required this.timeGoal,
      required this.habitStarted,
      required this.isDone});

// ignore: non_constant_identifier_names
  double PercentCompleted() {
    return timeSpent! / (timeGoal! * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Slidable(
        key: const ValueKey(1),
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.

          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) async {
                await delete.call();
              },
              flex: 1,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
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
                          percent:
                              PercentCompleted() < 1 ? PercentCompleted() : 1,
                          progressColor: PercentCompleted() > 0.5
                              ? (PercentCompleted() > 0.75
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.red,
                        ),
                        Center(
                          child: Icon(isDone == false
                              ? (habitStarted == true
                                  ? Icons.pause
                                  : Icons.play_arrow)
                              : Icons.check),
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
                    "$habitName",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 4),

                  //progress
                  Text(
                    formatMinSec +
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
      ),
    );
  }
}
