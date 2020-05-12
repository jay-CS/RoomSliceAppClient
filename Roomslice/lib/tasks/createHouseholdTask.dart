import 'package:flutter/material.dart';
import './taskCard.dart';


//TODO Find a way to read entries from server
class CreateHouseholdTask extends StatefulWidget {

  List<TaskCardState> tasks;
  CreateHouseholdTask(List<TaskCardState> list) {
    tasks = list;
  }

  @override
  _CreateHouseholdTaskState createState() => _CreateHouseholdTaskState(tasks);
  
}

class _CreateHouseholdTaskState extends State<CreateHouseholdTask> {


  Future<String> userName;
  Map<String, String> household = {};
  List<TaskCardState> tasks;

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
        return Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top:30, left: 85, right: 85),
            height: 194,
            width: 50,
            child: tasks[index]
          );
      }
    );
  }
}
