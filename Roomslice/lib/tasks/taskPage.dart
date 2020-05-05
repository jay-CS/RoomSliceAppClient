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

  List<TaskCard> task = new List<TaskCard>();
  // List<Widget> completedTasks = [];
  // List<Widget> userTasks = [];
  
  Future<String> userToken;

  @override
  void initState() {
    super.initState();
    FileWriter fw = new FileWriter();
    userToken = fw.readToken();
  }


  @override
  Widget build(BuildContext context) {
  
    task = [];
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
                  String token = snapshot.data.toString().substring(19,len-2).trim();
                  
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

                            if(result.data != null) {
                                getCardInfo(result.data["tasks"]);
                                List<Widget> tasks = [
                                  CreateHouseholdTask(task),
                                  Text(""),
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
                                          taskDialog(context,token);
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

  void getCardInfo(List list) {

    String taskName;
    String taskDescription;
    String current;
    String dueDate;
    bool isComplete;

    for(int i = 0; i < list.length; i++) {
      for (int j = 0 ; j < list[i].length; j++) {
        taskName = list[i][j]["name"];
        taskDescription = list[i][j]["description"];
        dueDate = list[i][j]["dueDate"];
        isComplete = list[i][j]["complete"];
        current = list[i][j]["current"]["firstName"];
        task.add(TaskCard(taskName, taskDescription, dueDate, current, isComplete));
      }
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

  Future<Widget> taskDialog(context, String token) {

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
                      if(resultData != null) {
                        print("Oncompleted: $resultData" ) ;
                      }
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
                                  runMutation({"name": current.text, "description":taskDescription.text, "dueDate": dueDate.text, "frequency": frequency.text , "current": current.text, "rotation":[3,4,5]});
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