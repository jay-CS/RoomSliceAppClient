import 'package:flutter/material.dart';
import './taskCard.dart';


//TODO Find a way to read entries from server
class CreateHouseholdTask extends StatefulWidget {

  List<TaskCard> tasks;
  CreateHouseholdTask(List<TaskCard> list) {
    tasks = list;
  }

  @override
  _CreateHouseholdTaskState createState() => _CreateHouseholdTaskState(tasks);
  
}

class _CreateHouseholdTaskState extends State<CreateHouseholdTask> {


  Future<String> userName;
  Map<String, String> household = {};
  List<TaskCard> tasks;

  _CreateHouseholdTaskState(list) {
    tasks = list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      color: Colors.purple[150],
      height: double.infinity,
      child: householdList(context),
    );
  }

  ListView householdList(context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, int index) {
        return Dismissible(
          key: ValueKey(index),
          onDismissed: (direction) {

            //Why does it remove it still in the opposite direction
            if(direction == DismissDirection.endToStart) {
              setState(() {
                tasks.removeAt(index);
              });
            }
          },
            child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top:30, left: 85, right: 85),
            height: 194,
            width: 50,
            child: tasks[index]
          ),
        );
      }
    );
  }
}
