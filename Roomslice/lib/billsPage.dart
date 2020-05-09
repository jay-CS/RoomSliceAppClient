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





List<String> roomList = ["All Roommates", "Select..."];
List roomies;




final HttpLink httpLink = HttpLink(
    uri: 'http://ubuntu@ec2-3-22-167-219.us-east-2.compute.amazonaws.com/graphql/',
    headers: {
      //"Authorization":"JWT $token"

    }
);


ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: httpLink,
  ),
);



String readRoommates ="""
query{


        users{
          id
          firstName
          lastName
          
          household{
            id
            name
          }
        }
        

}
""";


class BillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return

      GraphQLProvider(
          client: client,
          child:

          Query(
              options: QueryOptions(documentNode: gql(readRoommates),

              ),
              builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hasException) {
                  print(result.exception.toString());
                }

                if (result.data != null && result.data.toString() != null) {
                  roomies = result.data['users'];

                  roomList = ["All Roommates", "Select..."];

                  for (int i = 0; i < roomies.length; i++){

                    if ((roomies[i]["household"]) != null) {

                      roomList.insert(1,
                          roomies[i]["firstName"] + " " + roomies[i]["lastName"]);

                    }

                  }


                  return new Scaffold(

                    backgroundColor: Colors.purple[200],

                    body:
                    new ListDisplay(),
                  );
                }


                else
                  return Container();
              }
          )
      );
  }




}


class ListDisplay extends StatefulWidget {
  @override
  State createState() => new DynamicList();



}

class DynamicList extends State<ListDisplay> {


  BillBox creating;
  List<Widget> billList = [

    Text("My Bills"),
    Text("Pending Bllls"),
    Text("Bill History"),








  ];










  void pickDate(){

    print(roomies.length);
    print(roomies);
    print(roomies[0]["firstName"]);


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


      creating.billPay = value;

      creating.refreshBill();





    });



    futureDate.whenComplete(() {


      print("finished");

    });

  }


  Future<void> createBill(){


    creating = new BillBox();
    creating.dateOnly = true;

    String dropdownValue = "Monthly";
    String roommatesValue = roomList[0];

    bool isVisible = false;
    bool isVisibleRM = false;




    final TextEditingController eCtrl = new TextEditingController();
    final TextEditingController eCtrlTitle = new TextEditingController();



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


                                  DropdownButton<String>(
                                    value: roommatesValue,
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

                                      if (newValue == "Select..."){
                                        isVisibleRM = true;
                                      } else{
                                        isVisibleRM = false;
                                      }

                                      setState(() {


                                        roommatesValue = newValue;
                                        creating.userName.clear();
                                        creating.userName.add(roommatesValue);
                                        creating.manager = creating.userName[0];



                                      });
                                    },





                                    items: roomList
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                        .toList(),
                                  ),





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


                                        if (newValue == 'Custom'){


                                          isVisible = true;

                                          setState(() {

                                          });
                                        } else{


                                          isVisible = false;
                                          setState(() {

                                          });
                                        }
                                      });

                                      creating.cycleString = newValue;





                                    },
                                    items: <String>['Once','Weekly', 'Biweekly', 'Monthly', 'Custom']
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
                                visible: isVisibleRM,
                                child:  Column(
                                  mainAxisSize:  MainAxisSize.min,
                                  children: <Widget>[

                                    CheckboxGroup(
                                      labels: roomList.sublist(1,roomList.length-1),
                                      disabled: [

                                      ],
                                      onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
                                      onSelected: (List<String> checked) {
                                        print("checked: ${checked.toString()}");

                                        creating.userName = checked;
                                        if (checked.length >0) {
                                          creating.manager = checked[0];
                                        }
                                      },
                                    ),


                                  ],
                                ),

                              ),

                              Visibility (
                                visible: isVisible,
                                child:  new TextField(
                                  decoration: new InputDecoration(labelText: "Custom Cycle Length"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered

                                  onSubmitted:(value){
                                    creating.cycle = int.parse(value);
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

                              CheckboxListTile(
                                title: Text("Rotate"), //    <-- label
                                value: creating.rotating,
                                onChanged: (newValue) {
                                  creating.rotating = newValue;
                                  setState(() {

                                  }); },
                              )

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


                creating.cycleString = dropdownValue;

                BillBox temp = creating;



                billList.insert(1, temp);

                creating = new BillBox();
                Navigator.of(context).pop();
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
  bool rotating=false;
  Color activeColor = Colors.purple[300];
  Color inactiveColor = Colors.grey;
  Color overdueColor = Colors.red;

  int cycle;
  String cycleString;

  List<String> userName= ["UserName"];
  String manager = "All Roommates";

  String billTitle = "No Title";

  int displaySection = 1;

  //String flags;

  DateTime billPay = new DateTime.now();

  double billPrice=0;

  double paid = 0;

  bool fullyPaid = false;


  Function refreshBill;







  @override
  State createState() => new DynamicBill();

}


class DynamicBill extends State<BillBox> {

  final TextEditingController eCtrl = new TextEditingController();

  BillBox editing = new BillBox();


  void updateMembers(BillBox oldBill, BillBox newBill){
    if (this.mounted) {
      setState(() {
        oldBill.rotating = newBill.rotating;
        oldBill.cycle = newBill.cycle;
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


      editing.billPay = value;

      editing.refreshBill();





    });



    futureDate.whenComplete(() {


      print("finished");

    });

  }



  Future<void> billDetails(){


    editing = widget;
    editing.dateOnly = true;

    String dropdownValue = widget.cycleString;
    String roommatesValue = widget.manager;
    bool isVisible = false;
    bool isVisibleRM = false;

    if (widget.userName.length>1){
      roommatesValue = "Select...";
      isVisibleRM = true;

    }






    final TextEditingController eCtrl = new TextEditingController();
    final TextEditingController eCtrlTitle = new TextEditingController();

    eCtrl.text = widget.billPrice.toStringAsFixed(2);
    eCtrlTitle.text = widget.billTitle;



    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bill Details'),
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


                                  DropdownButton<String>(
                                    value: roommatesValue,
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

                                      if (newValue == "Select..."){
                                        isVisibleRM = true;
                                      } else{
                                        isVisibleRM = false;
                                        editing.userName.clear();
                                        editing.userName.add(roommatesValue);
                                        editing.manager = editing.userName[0];
                                      }

                                      setState(() {


                                        roommatesValue = newValue;
                                        editing.userName.clear();




                                      });
                                    },





                                    items: roomList
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                        .toList(),
                                  ),





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


                                        if (newValue == 'Custom'){


                                          isVisible = true;

                                          setState(() {

                                          });
                                        } else{


                                          isVisible = false;
                                          setState(() {

                                          });
                                        }
                                      });

                                      editing.cycleString = newValue;





                                    },
                                    items: <String>['Once','Weekly', 'Biweekly', 'Monthly', 'Custom']
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
                                visible: isVisibleRM,
                                child:  Column(
                                  mainAxisSize:  MainAxisSize.min,
                                  children: <Widget>[

                                    CheckboxGroup(
                                      labels: roomList.sublist(1,roomList.length-1),
                                      checked: editing.userName,
                                      disabled: [

                                      ],
                                      onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
                                      onSelected: (List<String> checked) {
                                        print("checked: ${checked.toString()}");
                                        setState(() {
                                          editing.userName = checked;

                                          if (checked.length >0) {
                                            editing.manager = checked[0];
                                          }
                                        });


                                      },
                                    ),


                                  ],
                                ),

                              ),

                              Visibility (
                                visible: isVisible,
                                child:  new TextField(
                                  decoration: new InputDecoration(labelText: "Former Cycle Length : "+widget.cycle.toString()+" days"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered

                                  onSubmitted:(value){
                                    editing.cycle = int.parse(value);
                                  },
                                ),

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

                              CheckboxListTile(
                                title: Text("Rotate"), //    <-- label
                                value: widget.rotating,
                                onChanged: (newValue) {
                                  widget.rotating = newValue;
                                  setState(() {

                                  }); },
                              )

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


                editing.cycleString = dropdownValue;


                updateMembers(widget, editing);




                Navigator.of(context).pop();
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

    if (widget.rotating){
      detailIcon = Icon(Icons.refresh);
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
                  color: widget.activeColor,
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