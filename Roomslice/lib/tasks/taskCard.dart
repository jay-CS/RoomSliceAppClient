import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:roomslice/FileWriter.dart';

class TaskCard extends StatelessWidget {

  String taskname;
  String taskDescripton;
  String rotation;
  String frequency;
  String date;
  String current;
  bool isComplete;

  TaskCard(String taskname, String taskDescripton, String date, String current, bool isComplete) {
      this.current = current;
      this.taskname = taskname;
      this.taskDescripton = taskDescripton;
      this.date = date;
  }

void display() {
  print(taskname + "\n" + taskDescripton + "\n" + date + "\n" + current + "\n" + isComplete.toString());
}
  
  @override
  Widget build(BuildContext context) {
   
    return Card(
            margin: EdgeInsets.only(bottom:23),
            elevation: 20.0,
            color: Colors.teal[100],
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            ),
            child: 
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                _createCardHeader("$taskname",1),
                Divider(
                  height: 3.0,
                  color: Colors.black,
                  ),
                //Body
                Container(
                  height: 80,
                  //color: Colors.black26,
                  alignment: Alignment.bottomRight,
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 50,
                      //color: Colors.blue[50],
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 7.0,right: 7.0, bottom: .0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/logos/profile.png"),
                            ),
                        )
                      ),
                      VerticalDivider(
                        width: 5.0,
                        //color: Colors.black,
                        thickness: 1.5,
                      ),
                      Expanded(child: Text("$taskDescripton"))
                    ],
                  )
                ),
                Divider(
                  height: 3.0,
                  color: Colors.black,
                  ),
                //Ending
                Container(
                  height: 35,
                  //color: Colors.black26,
                  child: Row (
                    children: [
                      Container(child: Text("Frequency: 0")),
                      SizedBox(width: 5),
                      VerticalDivider(
                        width: 1,
                        color: Colors.black,
                      ),
                      Container(child: Padding (padding: EdgeInsets.only(left:10), child: Text("4/29/20"))),
                      SizedBox(width: 5),
                      VerticalDivider(
                        width: 1,
                        color: Colors.black,
                      ),
                      Container(child: Padding (padding: EdgeInsets.only(left:10), child: Text("Weekly"))),
                    ]
                  )
                ),
              ]
            )
        );
    }


  Widget _createCardHeader(String taskName, int priorityLevel) {
    return Container(
      
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
            Text(
              "$taskName",
              style: TextStyle(
                height: 1,
                letterSpacing: .25,
                color: Colors.black,
                fontSize: 13,
                decorationThickness: 10.00,
                decorationColor: Colors.blue,
              ),
              )
          ,
          SizedBox(width: 60,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left:100 ),
                          child: Text(
                "$current"
                ),
            )
          )
        ] 
      )
    );
  }
}