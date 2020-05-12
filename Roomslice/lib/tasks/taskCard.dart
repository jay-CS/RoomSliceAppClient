import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:roomslice/FileWriter.dart';

class TaskCardState extends StatefulWidget {

  String token;
  String taskname;
  String taskDescripton;
  String rotation;
  String frequency;
  String date;
  String current;
  String id;
  bool isComplete;

  

  TaskCardState(String taskname, String taskDescripton, String date, String current, bool isComplete, String frequency, String id, String token)  {
      this.current = current;
      this.taskname = taskname;
      this.taskDescripton = taskDescripton;
      this.date = date;
      this.isComplete = isComplete;
      this.frequency = frequency;
      this.id = id;
      this.token = token;
  }

  @override
  _TaskCardState createState() => _TaskCardState(taskname, taskDescripton,date, current,  isComplete, frequency,  id,  token);

  
  
}

class _TaskCardState extends State<TaskCardState> {

// class TaskCard extends StatelessWidget {

  String token;
  String taskname;
  String taskDescripton;
  String rotation;
  String frequency;
  String date;
  String current;
  String id;
  bool isComplete;

 _TaskCardState(String taskname, String taskDescripton, String date, String current, bool isComplete, String frequency, String id, String token) {
      this.current = current;
      this.taskname = taskname;
      this.taskDescripton = taskDescripton;
      this.date = date;
      this.isComplete = isComplete;
      this.frequency = frequency;
      this.id = id;
      this.token = token;
  }

// void display() {
//   print(taskname + "\n" + taskDescripton + "\n" + date + "\n" + current + "\n" + isComplete.toString());
// }
  
 
  @override
  Widget build(BuildContext context) {

    String taskMutation = r''' mutation DeleteTask($taskId: Int!) {
                                deleteTask(taskId: $taskId) {
                                    ok
                                }
                            }
                            ''';
   
   final HttpLink httpLink =
        HttpLink(uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                headers: {
                "Authorization":"JWT $token"
                  }
        );

      final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
          link: httpLink,
          cache: InMemoryCache(),
        ),
      );

            return GraphQLProvider(
                client: client,
                child: Mutation(
                  options: MutationOptions(
                    documentNode: gql(taskMutation),
                    update: (Cache cache, QueryResult result) {
                      return cache;
                    },

                    onCompleted: (dynamic resultData) {
                      

                    }, 

                    onError: (onError) {
                      print("error $onError");
                    }
                  ), 

              builder: (RunMutation runMutation, QueryResult result) {

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
                      Container(child: Text(getFrequency("$frequency"))),
                      SizedBox(width: 5),
                      VerticalDivider(
                        width: 1,
                        color: Colors.black,
                      ),
                      Container(child: Padding (padding: EdgeInsets.only(left:10), child: Text("$date"))),
                      SizedBox(width: 5),
                      Container(
                        //padding: EdgeInsets.only(left:10),
                        width: 25,
                         child: RaisedButton(
                              elevation: 5.0,
                              color: Colors.red,
                              onPressed: () {
                                  int taskid = int.parse(id);
                                  setState(() {
                                    runMutation({"taskId" : taskid});
                                  });
                              },
                         )
                      ),
                    ],
                  )
                ),
              ]
            )
        );
      }
    )
    );


    }

  String getFrequency(String f) {
    String freq = "Every ";
    

    for(int i =0; i < 10; i++) {
      if(f.contains(i.toString()) == true) {
        freq += i.toString();
      }
    }

    if(f.contains("W") == true) {
      freq+= " Weeks";
    }
    if(f.contains("M") == true) {
      freq+= "Months";
    }

    if(f.contains("Y") == true){
      freq+= "Years";
    }

    if(f.contains("D")) {
     freq+= "Daily";
    }

    if(f.contains("X0")) {
      freq+= "None";
    }

    return freq;

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
          SizedBox(width: 40,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left:50 ),
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