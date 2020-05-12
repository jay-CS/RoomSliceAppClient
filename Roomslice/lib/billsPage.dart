import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'textWrapper.dart';
import 'dart:async';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:grouped_buttons/grouped_buttons.dart';


import './FileWriter.dart';
import 'package:http/http.dart';

import 'package:graphql_flutter/graphql_flutter.dart';







double scrnWidth = 0;
double scrnHeight = 0;
double blockSize = 0;
double blockSizeVertical = 0;

String globtoken;




List<String> roomList = [];
List<Widget> billList = [

  Text("My Bills"),
  Text("Pending Bllls"),
  Text("Bill History"),
];


List roomies;
List billies;







class BillsPage extends StatelessWidget {





  @override
  Widget build(BuildContext context) {


    Future<String> userName;
    FileWriter fw = new FileWriter();
    userName = fw.readToken();

    userName.then((value){

      print("VALUE  "+value);

    });

    return




      FutureBuilder(
          future: userName,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return Container();
              case ConnectionState.waiting:
                return Container();
              case ConnectionState.none:
                return Container();
              case ConnectionState.done:
              //------------------------------------Retrieving User JWT Token--------------------------------//
                int len = snapshot.data
                    .toString()
                    .length;
                print(snapshot.data.toString());

                String token = snapshot.data.toString()
                    .substring(19, len - 2)
                    .trim();

                globtoken = token;
                //print("TOKEN" + token);

                //------------------------------------Initialzing GraphQL Client(User) and Query-------------------------------//
                String readBills = '''query {
    bills {
        ... on BillListType {
            data {
                id
                name
                totalBalance
                isActive
              	dueDate
              	manager{
                  firstName
                  lastName
                  id
                }
                cycles {
                    recipient {
                        firstName
                      	lastName
                      	id
                    }
                isPaid
                }
            }
        }
        ... on CycleListType {
            data {
                bill {
                id
                name
                totalBalance
                isActive
                frequency
              	dueDate
              	manager{
                  firstName
                  lastName
                  id
                }
                cycles {
                    recipient {
                        firstName
                      	lastName
                      	id
                    }
                isPaid
                }
                }
            amount
        	}
        }
    }
}


''';


                String readRoommates = '''query {
                                              homepage {
                                                ... on HouseholdType {
                                                    name
                                                }
                                                
                                                ... on UserType{
                                                    firstName
                                                    lastName
                                                    id
                                                    status
                                                }
                                                
                                              }
                                          }''';
                final HttpLink httpLink =
                HttpLink(
                    uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                    headers: {
                      "Authorization": "JWT $token"
                    }
                );

                final ValueNotifier<GraphQLClient> client = ValueNotifier<
                    GraphQLClient>(
                  GraphQLClient(
                    link: httpLink,
                    cache: InMemoryCache(),
                  ),
                );


                return GraphQLProvider(
                    client: client,
                    child:

                    Query(
                        options: QueryOptions(documentNode: gql(readRoommates),

                        ),
                        builder: (QueryResult result,
                            {VoidCallback refetch, FetchMore fetchMore}) {




                          if (result.hasException) {
                            print(result.exception.toString());
                          }

                          if (result.data != null &&
                              result.data.toString() != null) {
                            roomies = result.data['homepage'];

                            roomList = [];


                            for (int i = 1; i < roomies.length; i++) {

                              roomList.insert(0,

                                  roomies[i]["firstName"] + " " +
                                      roomies[i]["lastName"]+ " <id "+
                                      roomies[i]["id"]+
                                      ">");

                            }


                            return


                              Query(
                                  options: QueryOptions(documentNode: gql(readBills),

                                  ),
                                  builder: (QueryResult result,
                                      {VoidCallback refetch, FetchMore fetchMore}) {
                                    if (result.hasException) {
                                      print(result.exception.toString());
                                    }

                                    if (result.data != null &&
                                        result.data.toString() != null) {
                                      print("WACK");
                                      print(result.data["bills"]);
                                      print(result.data["bills"][1]);



                                      billies = result.data["bills"];
                                      //billies2 = billies[1]["data"][0]["bill"];


                                      billList = [

                                        Text("My Bills"),
                                        Text("Pending Bllls"),
                                        Text("Bill History"),
                                      ];


                                      for (int i = 0; i < billies.length ; i++) {
                                        try {
                                          BillBox nBbox = new BillBox();
                                          nBbox.billTitle =
                                          billies[i]["data"][0]["name"];
                                          nBbox.billPrice =
                                          billies[i]["data"][0]["totalBalance"];
                                          nBbox.fullyPaid =
                                          !billies[i]["data"][0]["isActive"];
                                          nBbox.userName.clear();

                                          nBbox.cycleString =
                                          billies[i]["data"][0]["frequency"];


                                          nBbox.id = int.parse(
                                              billies[i]["data"][0]["id"]);


                                          for (int j = 0; j <
                                              billies[i]["data"][0]["cycles"]
                                                  .length; j++) {
                                            try {
                                              nBbox.userName.add(
                                                  billies[i]["data"][0]["cycles"][j]["recipient"]["firstName"] +
                                                      " " +
                                                      billies[i]["data"][0]["cycles"][j]["recipient"]["lastName"] +
                                                      " <id " +
                                                      billies[i]["data"][0]["cycles"][j]["recipient"]["id"] +
                                                      ">");


                                              if (billies[i]["data"][0]["cycles"][j]["isPaid"]) {
                                                nBbox.userNamePaid.add(
                                                    billies[i]["data"][0]["cycles"][j]["recipient"]["firstName"] +
                                                        " " +
                                                        billies[i]["data"][0]["cycles"][j]["recipient"]["lastName"] +
                                                        " <id " +
                                                        billies[i]["data"][0]["cycles"][j]["recipient"]["id"] +
                                                        ">");
                                              }
                                            } catch (exception) {

                                            }
                                          }


                                          nBbox.billPay = DateTime.parse(billies[i]["data"][0]["dueDate"]);


                                          nBbox.paid = billies[i]["data"][0]["amount"];


                                          nBbox.manager = billies[i]["data"][0]["manager"]["firstName"] +
                                              " " + billies[i]["data"][0]["manager"]["lastName"] +
                                              " <id " + billies[55]["data"][0]["manager"]["id"] +
                                              ">";


                                          if (nBbox.id == null) {
                                            billList.insert(3, nBbox);
                                          }

                                          else if (nBbox.fullyPaid) {
                                            billList.insert(2, nBbox);
                                          } else {
                                            billList.insert(1, nBbox);
                                          }
                                        } catch (exception) {


                                        }

                                        i = 1;


                                        print("EEE");

                                        print(billies[i]["data"][0]["bill"]["cycles"]);

                                        try {
                                          BillBox nBbox = new BillBox();


                                          nBbox.billTitle =
                                          result.data["bills"][i]["data"][0]["bill"]["name"];
                                          nBbox.billPrice =
                                          result.data["bills"][i]["data"][0]["bill"]["totalBalance"];
                                          nBbox.fullyPaid =
                                          !result.data["bills"][i]["data"][0]["bill"]["isActive"];
                                          nBbox.userName.clear();


                                          nBbox.cycleString =
                                          result.data["bills"][i]["data"][0]["bill"]["frequency"];

                                          nBbox.id = int.parse(
                                              result.data["bills"][i]["data"][0]["bill"]["id"]);


                                          for (int j = 0; j <
                                              result.data["bills"][i]["data"][0]["bill"]["cycles"]
                                                  .length; j++) {
                                            try {
                                              nBbox.userName.add(
                                                  billies[i]["data"][0]["bill"]["cycles"][j]["recipient"]["firstName"] +
                                                      " " +
                                                      billies[i]["data"][0]["bill"]["cycles"][j]["recipient"]["lastName"] +
                                                      " <id " +
                                                      billies[i]["data"][0]["bill"]["cycles"][j]["recipient"]["id"] +
                                                      ">");


                                              if (billies[i]["data"][0]["bill"]["cycles"][j]["isPaid"]) {
                                                nBbox.userNamePaid.add(
                                                    billies[i]["data"][0]["bill"]["cycles"][j]["recipient"]["firstName"] +
                                                        " " +
                                                        billies[i]["data"][0]["bill"]["cycles"][j]["recipient"]["lastName"] +
                                                        " <id " +
                                                        billies[i]["data"][0]["bill"]["cycles"][j]["recipient"]["id"] +
                                                        ">");
                                              }
                                            } catch (exception) {

                                            }
                                          }


                                          nBbox.billPay = DateTime.parse(billies[i]["data"][0]["bill"]["dueDate"]);


                                          nBbox.paid = billies[i]["data"][0]["bill"]["amount"];


                                          nBbox.manager = billies[i]["data"][0]["bill"]["manager"]["firstName"] +
                                              " " + billies[i]["data"][0]["bill"]["manager"]["lastName"] +
                                              " <id " + billies[i]["data"][0]["bill"]["manager"]["id"] +
                                              ">";


                                          if (nBbox.id == null) {
                                            billList.insert(3, nBbox);
                                          }

                                          else if (nBbox.fullyPaid) {
                                            billList.insert(2, nBbox);
                                          } else {
                                            billList.insert(1, nBbox);
                                          }
                                        } catch (exception) {


                                        }
                                      }


                                      return new Scaffold(

                                        backgroundColor: Colors.purple[200],

                                        body:
                                        new ListDisplay(),
                                      );
                                    }


                                    else {
                                      return Container();
                                    }
                                  }
                              );





                          }


                          else {
                            return Container();
                          }
                        }
                    )
                );
            }
          }
      );




  }




}


class ListDisplay extends StatefulWidget {
  @override
  State createState() => new DynamicList();



}

class DynamicList extends State<ListDisplay> {


  BillBox creating;











  void pickDate(){

    DateTime nowDate = DateTime.now();



    Future <DateTime> futureDate;

    futureDate = showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: nowDate,
      lastDate: nowDate.add(Duration(days: 365)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );


    futureDate.then((value)  {



      if(value!=null) {
        creating.billPay = value;

        creating.refreshBill();
      }




    });

    futureDate.catchError((onError){


      creating.billPay = DateTime.now();

      creating.refreshBill();

    });



    futureDate.whenComplete(() {


      print("finished");

    });

  }


  Future<void> createBill(){


    creating = new BillBox();
    creating.dateOnly = true;

    String dropdownValue = "Days";

    creating.userName.add(roomList.last);
    creating.manager = roomList.last;

    roomList = roomList.reversed.toList();

    bool isVisible = true;




    final TextEditingController eCtrl = new TextEditingController();
    final TextEditingController eCtrlTitle = new TextEditingController();
    final TextEditingController eCtrlCycle = new TextEditingController();

    eCtrlCycle.text = "1";






































    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create A Bill'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      return


                        Column(

                            children: <Widget>[


                              new TextField(
                                controller: eCtrlTitle,
                                maxLength: 20,
                                decoration: new InputDecoration(
                                  labelText: "Bill Title",



                                ),
                                keyboardType: TextInputType.text,


                                onEditingComplete: (){

                                  creating.billTitle = eCtrlTitle.text;



                                },


                                onSubmitted: (value){

                                  creating.billTitle = eCtrlTitle.text;

                                },

                              ),



                              new TextField(
                                controller: eCtrl,
                                decoration: new InputDecoration(
                                  labelText: "Total Bill Cost",
                                  icon: Icon(Icons.attach_money),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                                inputFormatters: <TextInputFormatter>[


                                ], // Only numbers can be entered


                                onEditingComplete: (){





                                  String newTxt = eCtrl.text;

                                  if(newTxt.endsWith(".")){
                                    newTxt = newTxt.substring(0,newTxt.indexOf("."));
                                  }

                                  newTxt+=".00";

                                  print(newTxt);
                                  newTxt = newTxt.substring(0,newTxt.indexOf(".")+3);

                                  if(newTxt.endsWith(".")){
                                    newTxt = newTxt.substring(0,newTxt.indexOf(".")+2);
                                  }

                                  print(newTxt);

                                  newTxt = double.parse(newTxt).toStringAsFixed(2);

                                  print(newTxt);


                                  eCtrl.text = newTxt;

                                  creating.billPrice = double.parse(newTxt);

                                },


                                onSubmitted: (value){

                                  creating.billPrice = double.parse(value);

                                },

                              ),



                              Row(

                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget> [

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 6),
                                    child:
                                    Text("Manager: "+creating.manager),
                                  ),





                                ],
                              ),

                              Column(
                                mainAxisSize:  MainAxisSize.min,
                                children: <Widget>[

                                  CheckboxGroup(
                                    labels: roomList,

                                    checked: creating.userName,

                                    disabled: [

                                    ],
                                    onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
                                    onSelected: (List<String> checked) {
                                      print("checked: ${checked.toString()}");
                                      setState(() {
                                        creating.userName = checked;
                                      });


                                      if (!checked.contains(creating.manager)){
                                        checked.add(creating.manager);
                                      }

                                    },
                                  ),




                                ],
                              ),


                              Row (

                                children: <Widget>[

                                  Text("Frequency: "),

                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.deepPurple
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;

                                        creating.cycleString = newValue[0];

                                        if (newValue == 'None'){

                                          creating.cycleString = 'X';


                                          isVisible = false;

                                          setState(() {

                                          });
                                        } else{


                                          isVisible = true;
                                          setState(() {

                                          });
                                        }
                                      });







                                    },
                                    items: <String>['Days','Weeks', 'Months', 'Years', 'None']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                        .toList(),
                                  ),

                                ],
                              ),

                              Visibility (
                                visible: isVisible,
                                child:  new TextField(
                                  controller: eCtrlCycle,
                                  decoration: new InputDecoration(labelText: "Number of "+dropdownValue),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered

                                  onChanged:(value){

                                    creating.cycleString += dropdownValue+value;
                                  },

                                  onEditingComplete:(){
                                    if (eCtrlCycle.text=="" || eCtrlCycle.text == "0"){
                                      eCtrlCycle.text = "1";

                                    }
                                  },

                                  onSubmitted:(value){
                                    creating.cycleString = dropdownValue+value;
                                  },
                                ),

                              ),



                              Row(
                                  children:<Widget>[



                                    DynamicBill().constructFlatButton("Start Date", pickDate),

                                    Padding(

                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                      child:
                                      creating,
                                    ),






                                  ]
                              ),


                            ]
                        );

                    }),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Create'),
              onPressed: () {



                creating.billTitle = eCtrlTitle.text;
                creating.billPrice = double.parse(eCtrl.text);
                creating.dateOnly = false;

                if(creating.cycleString != "X" && (eCtrlCycle.text == "0" || eCtrlCycle.text == "")){
                  eCtrlCycle.text = "1";
                }

                creating.cycleString = dropdownValue[0]+eCtrlCycle.text;

                BillBox temp = creating;



                billList.insert(1, temp);

                setState(() {

                });

                creating = new BillBox();


                List<String> addedIds=[];

                for ( int i = 0; i < temp.userName.length ; i++){
                  addedIds.add(temp.userName[i].split("<id ").last.replaceAll(">", ""));


                }




                String createBill = '''mutation {
    createBill (name: "'''+temp.billTitle+'''", totalBalance: "'''+temp.billPrice.toString()+'''", dueDate: "'''+temp.billPay.day.toString().padLeft(2,"0")+temp.billPay.month.toString().padLeft(2,"0")+temp.billPay.year.toString()+'''", frequency:"'''+temp.cycleString+'''", participants:'''+addedIds.toString()+''' ){
        bill {
            name
            id
            manager {
                firstName
            }
            dueDate
            frequency
            isActive
            totalBalance
            participants {
                firstName
            }
        }
     }
    }
''';

                print(createBill);
                print(globtoken);
                final HttpLink httpLink =
                HttpLink(
                    uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                    headers: {
                      "Authorization": "JWT $globtoken"
                    }
                );

                final ValueNotifier<GraphQLClient> client = ValueNotifier<
                    GraphQLClient>(
                  GraphQLClient(
                    link: httpLink,
                    cache: InMemoryCache(),
                  ),
                );





                showDialog(
                  context: this.context,
                  child:new AlertDialog(
                    content: new FlatButton(
                      child: GraphQLProvider(
                        client: client,
                        child: Query( //Actually a Mutation
                            options: QueryOptions(
                              documentNode: gql(createBill),

                            ),

                            builder: (QueryResult result,
                                {VoidCallback refetch, FetchMore fetchMore}) {

                              print(result.data);

                              return Text("Done");

                            }



                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                );







              },
            ),
          ],
        );
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    scrnWidth = MediaQuery
        .of(context)
        .size
        .width;
    scrnHeight = MediaQuery
        .of(context)
        .size
        .height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;


    return

      Column(

        children: <Widget>[

          AppBar(

            title: Text("Bills"),


            actions: <Widget>[

              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child:
                  DynamicBill().constructFlatButton("+", createBill)
              ),
            ],



          ),
























          Expanded(


              child:

              ReorderableListView(

                onReorder: (oldIndex, newIndex) {
                  try {
                    print("1");
                    if (billList[oldIndex] is BillBox && billList[newIndex] is BillBox &&
                        newIndex != 0 && newIndex < billList.length) {
                      BillBox t1 = billList[oldIndex];
                      BillBox t2 = billList[newIndex];
                      print("2");
                      if (t1.displaySection == t2.displaySection) {
                        Widget old = billList[oldIndex];
                        print("3");
                        if (oldIndex > newIndex) {
                          print("4");
                          for (int i = oldIndex; i > newIndex; i--) {
                            billList[i] = billList[i - 1];
                          }
                          billList[newIndex] = old;
                        } else {
                          print("5");
                          for (int i = oldIndex; i < newIndex - 1; i++) {
                            billList[i] = billList[i + 1];
                          }
                          billList[newIndex - 1] = old;
                        }
                        setState(() {});
                      }
                    }
                  }
                  catch( exception ){

                  }
                },

                children: billList.map((Widget string) => ListTile(key: Key(billList[billList.indexOf(string)].toString()+billList.indexOf(string).toString()), title: string)).toList(),

              )
          ),
        ],
      );
  }



}

class DateAlert extends StatefulWidget{








  @override
  State createState() => new DynamicBill();

}




class BillBox extends StatefulWidget{



  bool dateOnly = false;
  Color activeColor = Colors.purple[300];
  Color inactiveColor = Colors.grey;
  Color overdueColor = Colors.red;

  int cycle;
  String cycleString = "D0";

  List<String> userName= [];
  List<String> userNamePaid = [];
  String manager = "N/A";

  String billTitle = "No Title";

  int displaySection = 1;

  int id = 0;


  DateTime billPay = new DateTime.now();

  double billPrice=0;

  double paid = 0;

  bool fullyPaid = false;


  Function refreshBill;







  @override
  State createState() => new DynamicBill();

}


class DynamicBill extends State<BillBox> {



  BillBox editing = new BillBox();


  void updateMembers(BillBox oldBill, BillBox newBill){
    if (this.mounted) {
      setState(() {
        oldBill.cycleString = newBill.cycleString;
        oldBill.userName = newBill.userName;
        oldBill.manager = newBill.manager;
        oldBill.billTitle = newBill.billTitle;
        oldBill.billPay = newBill.billPay;
        oldBill.billPrice = newBill.billPrice;
      });
    }

  }

  void editDate(){

    Future <DateTime> futureDate;

    futureDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );


    futureDate.then((value)  {

      if (value!=null) {
        editing.billPay = value;

        editing.refreshBill();
      }



    });



    futureDate.whenComplete(() {


      print("finished");

    });

  }



  Future<void> billDetails(){



    editing = widget;
    editing.dateOnly = true;

    print("BILL ID "+editing.id.toString());

    String dropdownValue ;

    if(widget.cycleString[0]=='D'){
      dropdownValue = "Days";
    }
    if(widget.cycleString[0]=='W'){
      dropdownValue = "Weeks";
    }
    if(widget.cycleString[0]=='M'){
      dropdownValue = "Months";
    }
    if(widget.cycleString[0]=='Y'){
      dropdownValue = "Years";
    }
    if(widget.cycleString[0]=='X'){
      dropdownValue = "None";
    }

    String roommatesValue = widget.manager;

    print(widget.userName);







    final TextEditingController eCtrl = new TextEditingController();
    final TextEditingController eCtrlTitle = new TextEditingController();

    eCtrl.text = widget.billPrice.toStringAsFixed(2);
    eCtrlTitle.text = widget.billTitle;




    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:

          Row (children:<Widget>[
            Text('Bill Details'),

            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed:() {

                return showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {

                    return AlertDialog(
                      title:
                      Text('Delete?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),

                        FlatButton(
                          child: Text('Delete'),
                          onPressed: () {


                            String deleteBill = '''mutation {
    deleteBill(billId: '''+editing.id.toString()+''') {
        ok
    }
}

''';


                            final HttpLink httpLink =
                            HttpLink(
                              uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                            );

                            final ValueNotifier<GraphQLClient> client = ValueNotifier<
                                GraphQLClient>(
                              GraphQLClient(
                                link: httpLink,
                                cache: InMemoryCache(),
                              ),
                            );


                            showDialog(
                              context: this.context,
                              child:new AlertDialog(
                                content: new FlatButton(
                                  child: GraphQLProvider(
                                    client: client,
                                    child: Query( //Actually a Mutation
                                        options: QueryOptions(
                                          documentNode: gql(deleteBill),


                                        ),

                                        builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {

                                          print(result.data);
                                          return Text("Deleted");
                                        }
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context, true);
                                    Navigator.pop(context, true);
                                    Navigator.pop(context,true);
                                  },
                                ),
                              ),
                            );


                          },
                        ),

                      ],
                    );

                  },
                );



              },
            ),


          ],),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      return


                        Column(

                            children: <Widget>[


                              new TextField(
                                controller: eCtrlTitle,
                                maxLength: 20,
                                decoration: new InputDecoration(
                                  labelText: "Bill Title",



                                ),
                                keyboardType: TextInputType.text,


                                onEditingComplete: (){

                                  editing.billTitle = eCtrlTitle.text;



                                },


                                onSubmitted: (value){

                                  editing.billTitle = eCtrlTitle.text;

                                },

                              ),



                              new TextField(
                                controller: eCtrl,
                                decoration: new InputDecoration(
                                  labelText: "Total Bill Cost",
                                  icon: Icon(Icons.attach_money),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                                inputFormatters: <TextInputFormatter>[


                                ], // Only numbers can be entered


                                onEditingComplete: (){





                                  String newTxt = eCtrl.text;

                                  if(newTxt.endsWith(".")){
                                    newTxt = newTxt.substring(0,newTxt.indexOf("."));
                                  }

                                  newTxt+=".00";

                                  print(newTxt);
                                  newTxt = newTxt.substring(0,newTxt.indexOf(".")+3);

                                  if(newTxt.endsWith(".")){
                                    newTxt = newTxt.substring(0,newTxt.indexOf(".")+2);
                                  }

                                  print(newTxt);

                                  newTxt = double.parse(newTxt).toStringAsFixed(2);

                                  print(newTxt);


                                  eCtrl.text = newTxt;

                                  editing.billPrice = double.parse(newTxt);

                                },


                                onSubmitted: (value){

                                  editing.billPrice = double.parse(value);

                                },

                              ),



                              Row(

                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget> [


                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 6),
                                    child:
                                    Text("Manager: "+editing.manager),
                                  ),






                                ],
                              ),



                              Column(
                                mainAxisSize:  MainAxisSize.min,
                                children: <Widget>[

                                  CheckboxGroup(
                                    labels: roomList,
                                    checked: editing.userName,
                                    disabled: [

                                    ],
                                    onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
                                    onSelected: (List<String> checked) {
                                      print("checked: ${checked.toString()}");
                                      setState(() {
                                        editing.userName = checked;

                                        if (!checked.contains(roommatesValue)){
                                          checked.add(roommatesValue);
                                        }


                                      });


                                    },
                                  ),


                                ],
                              ),



                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Text("Frequency: Every "+editing.cycleString.substring(1)+ " "+editing.cycleString[0]+"onth"),

                              ),



                              Row(
                                  children:<Widget>[



                                    DynamicBill().constructFlatButton("Start Date", editDate),

                                    Padding(

                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                      child:
                                      editing,
                                    ),






                                  ]
                              ),



                            ]
                        );

                    }),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Save'),
              onPressed: () {






                editing.billTitle = eCtrlTitle.text;
                editing.billPrice = double.parse(eCtrl.text);
                editing.dateOnly = false;
                editing.userNamePaid.clear();




                updateMembers(widget, editing);


                List<String> addedIds=[];
                List <String> removedIds=[];

                for ( int i = 0; i < roomList.length ; i++){
                  removedIds.add(roomList[i].split("<id ").last.replaceAll(">", ""));

                }

                for ( int i = 0; i < widget.userName.length ; i++){
                  addedIds.add(widget.userName[i].split("<id ").last.replaceAll(">", ""));
                  removedIds.remove(widget.userName[i].split("<id ").last.replaceAll(">", ""));

                }



                String updateBill = '''mutation {
    updateBill(billData: {billId: '''+editing.id.toString()+''', name: "'''+editing.billTitle+'''", totalBalance: "'''+editing.billPrice.toString()+'''", removeParticipants: '''+ removedIds.toString()  +''', addParticipants: '''+addedIds.toString()+''' }){
        bill {
          name
          id
          manager{
              firstName
          }
          dueDate
          frequency
          totalBalance
          isActive
          numSplit
          participants {
              firstName
          }
          cycles {
              recipient {
                  firstName
              }
              amount
              isPaid
              datePaid
          }
            
        }
    }
}
''';


                final HttpLink httpLink =
                HttpLink(
                  uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
                );

                final ValueNotifier<GraphQLClient> client = ValueNotifier<
                    GraphQLClient>(
                  GraphQLClient(
                    link: httpLink,
                    cache: InMemoryCache(),
                  ),
                );





                showDialog(
                  context: this.context,
                  child:new AlertDialog(
                    content: new FlatButton(
                      child: GraphQLProvider(
                        client: client,
                        child: Query( //Actually a Mutation
                            options: QueryOptions(
                              documentNode: gql(updateBill),


                            ),

                            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {

                              print(result.data);
                              return Text("Saved");
                            }
                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                );





              },
            ),
          ],
        );
      },
    );

  }





  Text constructBillDetails(String txtString, BuildContext context) {
    TextWrapper txtWrp = new TextWrapper(context);

    txtWrp.data = txtString;

    return txtWrp.constructText();
  }


  void refreshBillInternal(){

    setState(() {

    });

  }




  ButtonTheme constructFlatButton (String txtString, Function funct){

    return           ButtonTheme(
      minWidth: scrnWidth*.09,
      child:
      FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(100.0),
            side: BorderSide(color: Colors.black)),
        color: Colors.white,
        textColor: Colors.deepPurple,
        padding: EdgeInsets.all(8.0),
        onPressed: funct,
        child: Text(
          txtString.toUpperCase(),
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    Icon detailIcon= Icon(Icons.person);

    if (widget.userName.length > 1){

      detailIcon = Icon(Icons.group);
    }



    widget.refreshBill = refreshBillInternal;

    TextWrapper dueDate = TextWrapper(context);

    dueDate.data =
        "Due By: " + widget.billPay.month.toString().padLeft(2, '0') + "/" +
            widget.billPay.day.toString().padLeft(2, '0');

    dueDate.style = TextStyle(
      fontSize: blockSizeVertical * 2,
      color: Colors.white,

    );

    dueDate.textAlign = TextAlign.left;



    int multFactor;
    if(widget.cycleString[0]=='D'){
      multFactor = 1;
    }
    if(widget.cycleString[0]=='W'){
      multFactor = 7;
    }
    if(widget.cycleString[0]=='M'){
      multFactor = 30;
    }
    if(widget.cycleString[0]=='Y'){
      multFactor = 365;
    }
    if(widget.cycleString[0]=='X'){
      multFactor = 0;
    }

    widget.cycle = multFactor*int.parse(widget.cycleString.substring(1));





    Color pickedColor = widget.activeColor;
    if(widget.userNamePaid.length == widget.userName.length){

      widget.fullyPaid = true;

      pickedColor = widget.inactiveColor;

      int tempDay = widget.billPay.day;

      widget.billPay.add( Duration(days: widget.cycle));

      while (widget.billPay.day != tempDay && widget.cycleString[0]=='M'){
        widget.billPay.add(Duration(days: 1));
      }

    }



    if (DateTime.now().compareTo(widget.billPay)>=0){

      if(widget.fullyPaid){
        widget.userNamePaid.clear();

        widget.manager = widget.userName[(widget.userName.indexOf(widget.manager)+1)%widget.userName.length];

      }

      pickedColor = widget.overdueColor;

    }




    if (widget.dateOnly) {

      dueDate.style = TextStyle(
        fontSize: blockSizeVertical * 2,
        color: Colors.grey,

      );

      return dueDate.constructText();


    }

    else {
      return

        new


        Column(

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.manager +"\n"+ widget.billTitle),
                  detailIcon,
                ],
              ),
              Container(

                decoration: BoxDecoration(
                  color: pickedColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),

                child:
                ListTile(

                  leading:


                  constructBillDetails( "\$" +
                      widget.billPrice.toStringAsFixed(2), context),



                  subtitle: dueDate.constructText(),


                  trailing: constructFlatButton("Bill Details", billDetails),


                ),

              ),
            ]
        );
    }
  }
}