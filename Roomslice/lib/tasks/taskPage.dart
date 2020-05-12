import 'package:flutter/material.dart';
import './taskCard.dart';
import 'package:roomslice/FileWriter.dart';
import './createHouseholdTask.dart';
import 'package:graphql_flutter/graphql_flutter.dart';



class TaskPage extends StatefulWidget {
//TaskPage({Key key}) : super(key:key);
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  
  final taskName = new TextEditingController();
  final taskDescription = new TextEditingController();
  final dueDate  = new TextEditingController();
  final current = new TextEditingController();
  final frequency = new TextEditingController();

  List<TaskCardState> task = [];
  //List<Widget> completedTasks = [];
   List<TaskCardState> userTask = [];
  
  Future<String> userToken;

  @override
  void initState() {
    super.initState();
    FileWriter fw = new FileWriter();
    userToken = fw.readToken();
  }


  @override
  Widget build(BuildContext context) {
    String token;
    return DefaultTabController(
        length: 3,
        child: 
            FutureBuilder(
              future: userToken,
              builder: (context, snapshot) {
                
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  return Container();
                  case ConnectionState.waiting:
                  return Container();
                  case ConnectionState.none:
                  return Container();
                  case ConnectionState.done:
                    String taskQuery = """query {
                                          tasks {
                                          id
                                              name
                                              description
                                              dueDate
                                              frequency
                                              current
                                              {
                                                  firstName
                                              }
                                              complete
                                              rotation {
                                                  firstName
                                              }
                                          }
                                      }""";

                  int len = snapshot.data.toString().length;
                  token = snapshot.data.toString().substring(19,len-2).trim();
                  print("TOKEN " + token);
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
                      child: Query(
                        options: QueryOptions(
                          documentNode: gql(taskQuery),
                        ), 
                        builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                            task = [];
                            userTask = [];      
                            if(result.data != null) {
                                getCardInfo(result.data["tasks"],token);
                                List<Widget> tasks = [
                                  CreateHouseholdTask(task),
                                  CreateHouseholdTask(userTask),
                                  Text(""),
                                ];
                                return Scaffold(
                                      primary: true,
                                      backgroundColor: Colors.purple[100],
                                      floatingActionButton: FloatingActionButton(
                                        elevation: 10.00,
                                        child: Icon(Icons.add),
                                        backgroundColor: Colors.purple[400],
                                        onPressed: () { 
                                          print("pressed");
                                          taskDialog(context,token).then((onValue) {
                                            task.add(onValue);
                                          });
                                          },
                                        
                                      ),
                                      appBar: AppBar(
                                      backgroundColor: Colors.purple[400],
                                      centerTitle: true,
                                      title: Text(
                                        "Tasks",
                                      ),
                                      bottom: TabBar(
                                        tabs: createTabs(),
                                        ),
                                      ),
                                      body:TabBarView(physics: AlwaysScrollableScrollPhysics(),children: tasks));
                              }
                              if (result.hasException) {
                                 print(result.exception.toString());
                              } 
                            return Container();
                          }
                        ),
                    );
          }
        }
      ),

      );
  }


  List<Tab> createTabs() {
    return [
      Tab(
        child: Text("Household Tasks")
        ),
        Tab(
          child: Text("Your Tasks")
        ),
        Tab(
          child: Text("Completed Tasks")
        )
    ];
  }

  void getCardInfo(List list, String token) {

    String taskName;
    String taskDescription;
    String current;
    String dueDate;
    String frequency;
    String id;
    bool isComplete;

    print(list);
    for(int i = 0; i < list.length; i++) {
      for (int j = 0 ; j < list[i].length; j++) {
        taskName = list[i][j]["name"];
        taskDescription = list[i][j]["description"];
        dueDate = list[i][j]["dueDate"];
        isComplete = list[i][j]["complete"];
        current = list[i][j]["current"]["firstName"];
        frequency = list[i][j]["frequency"];
        id = list[i][j]["id"];
        task.add(TaskCardState(taskName, taskDescription, dueDate, current, isComplete,frequency,id,token));
      }
    }

    for(int i = 0; i < list.length; i++) {
      taskName = list[i][0]["name"];
      taskDescription = list[i][0]["description"];
      dueDate = list[i][0]["dueDate"];
      isComplete = list[i][0]["complete"];
      current = list[i][0]["current"]["firstName"];
      frequency = list[i][0]["frequency"];
      id = list[i][0]["id"];
      userTask.add(TaskCardState(taskName, taskDescription, dueDate, current, isComplete,frequency,id,token));

    }

   
  }

  Widget createTextField(String name, String hintText, controller) {

    return Row(
            children: <Widget>[
              Text(name),
              Expanded( 
                child: TextField(
                  controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText
                    ),
                ),
              )
            ]
          );
   }

  Future<TaskCardState> taskDialog(context, String token) {

    String createTask = r"""mutation CreateTask($name: String!, $description: String!, $dueDate: String!, $frequency: String!, $current: Int!, $rotation: [Int]) {
      createTask(
        name: $name,
        description: $description, 
        dueDate: $dueDate, 
        frequency: $frequency, 
        current: $current,
        rotation: $rotation) {
          task{
            name
            description
            dueDate
            frequency
            current {
                firstName
            }
            rotation{
                firstName
            } 
          }        
        }
      }""";

                  
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

    return showDialog(context: context,
          builder: (context) {
            return GraphQLProvider(
                client: client,
                child: Mutation(
                  options: MutationOptions(
                    documentNode: gql(createTask),
                    update: (Cache cache, QueryResult result) {
                      return cache;
                    },

                    onCompleted: (dynamic resultData) {
                      print(createTask);
                      // if(resultData != null) {
                      //   print("Oncompleted: $resultData" ) ;
                      //   List list = resultData[0];
                      //   print(list);
                      //    String taskName;
                      //     String taskDescription;
                      //     String current;
                      //     String dueDate;
                      //     String frequency;
                      //     String id;
                      //     bool isComplete;
                      //   taskName = list[0]["name"];
                      //   taskDescription = list[0]["description"];
                      //   dueDate = list[0]["dueDate"];
                      //   isComplete = list[0]["complete"];
                      //   current = list[0]["current"]["firstName"];
                      //   frequency = list[0]["frequency"];
                      //   id = list[0]["id"];
                      //   return task.add(TaskCardState(taskName, taskDescription, dueDate, current, isComplete,frequency,id,token));
                      //}
                    }, 

                    onError: (onError) {
                      print("error $onError");
                    }
                  ), 

              builder: (RunMutation runMutation, QueryResult result) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40.0)), //this right here
                  child: Container(
                    height: 400,
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //Create function that retturns List of rows
                        children: [
                          //createTextField("Rotation: ", 'Daily, Weekly, Monthly, etc'),
                          createTextField("Frequency: ", 'Times per week',frequency) ,
                          createTextField("Assigned: ", 'Type person in charge',current),
                          createTextField("Task Name: ", 'Type task name',taskName),
                          createTextField("Task description: ", 'Type description',taskDescription),
                          createTextField("Date: ", 'Date it must be completed by',dueDate),
                          
                          //Create function for creating buttton
                          SizedBox(
                            width: 320.0,
                            child: RaisedButton(
                              onPressed: () {
                                print("Saved");
                                setState(() {
                                  runMutation({"name": taskName.text, "description":taskDescription.text, "dueDate": dueDate.text, "frequency": frequency.text , "current": 3, "rotation":[3,4,5]});
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text("Save", style: TextStyle(color: Colors.white),),
                              color: const Color(0xFF1BC0C5),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              );
        }
          ),
      );
    });
  }

}