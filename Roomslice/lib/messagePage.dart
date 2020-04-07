import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textWrapper.dart';
import 'usefulFunctions.dart';
import 'dart:async';

double scrnWidth = 0;
double scrnHeight = 0;
double blockSize = 0;
double blockSizeVertical = 0;
MessageBox updatePinned;


class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      backgroundColor: Colors.purple[200],

      body:
      new ListDisplay(),
    );
  }




}


class ListDisplay extends StatefulWidget {
  @override
  State createState() => new DynamicList();



}

class DynamicList extends State<ListDisplay> {
  List<MessageBox> messages = [];
  List<MessageBox> pinned = [];



  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build (BuildContext context) {

    scrnWidth = MediaQuery.of(context).size.width;
    scrnHeight = MediaQuery.of(context).size.height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;

    Timer thistimer;
    thistimer = Timer.periodic(new Duration(milliseconds: 1000), updatePins);


    return


      Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Row(

              children:

              pinned,




            ),
          ),

          Expanded(
              child: new ListView.builder
                (
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (BuildContext context, int Index) {
                    return


                      messages[Index];
                  }
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child:      TextField(
              controller: eCtrl,
              maxLength: 250,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                hintText: "Send a message...",
                filled: true,
                fillColor: Colors.white,
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: new BorderSide(
                  ),

                ),


              ),

              onSubmitted: (text) {

                if(text.replaceAll(' ', '').length>0) {
                  TextWrapper genText = new TextWrapper(context);

                  genText.data = text;
                  genText.textWidthBasis = TextWidthBasis.longestLine;
                  genText.setStyle(TextStyle(
                    fontSize: blockSizeVertical * 3,
                    color: Colors.black,

                  ));

                  MessageBox msgBox = new MessageBox();
                  msgBox.textRows = genText;
                  msgBox.sentBy = new TextWrapper(context);
                  messages.insert(0, msgBox);


                  eCtrl.clear();
                  setState(() {});
                }
                else{
                  eCtrl.clear();
                }

              },

            ),

          ),
        ],

      );
  }

  void updatePins(Timer timer) {


    if (updatePinned != null) {
      print("NOTNULL");
      if (updatePinned.pinned == false) {

        pinned.remove(updatePinned);
      } else {
        pinned.insert(0, updatePinned);

      }
      setState(() {});
      setState(() {});
      updatePinned = null;
    }

  }

}


class MessageBox extends StatefulWidget{

  TextWrapper textRows;
  TextWrapper sentBy;
  double fontSize =0;
  int lineWidth=0;
  bool pinned = false;
  bool yours = true;
  Color pinnedColor = Colors.red;
  Color genColor = Colors.white;
  Color theirColor = Colors.purple;
  Color yourColor = Colors.green;
  TextDirection profTextOrder = TextDirection.ltr;
  AssetImage assetImage = AssetImage("assets/logos/profilePic.png");
  DateTime currentTime = new DateTime.now();





  @override
  State createState() => new DynamicMessage();

}


class DynamicMessage extends State<MessageBox> {

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    widget.fontSize=widget.textRows.getStyle().fontSize;
    widget.lineWidth = (widget.textRows.getData().length);

    print(widget.textRows.getData().length);

    widget.sentBy.setData("UserName");
    widget.sentBy.setStyle(TextStyle(
      fontSize: blockSizeVertical * 2,
      color: Colors.white,

    ));




    if(widget.yours){



      widget.textRows.setTextAlign(TextAlign.left);
      widget.genColor = widget.yourColor;
      widget.profTextOrder = TextDirection.rtl;

      if(widget.pinned == true){
        widget.genColor = widget.pinnedColor;
      }

    }
    else{
      widget.genColor = widget.theirColor;
      if(widget.pinned == true){
        widget.genColor = widget.pinnedColor;
      }
    }



    UsefulFunctions usFun = new UsefulFunctions();


    return

      new


      Column(
          children: <Widget>[

            Align(
              alignment: widget.yours ? Alignment.centerRight : Alignment.centerLeft,
              child:

              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: widget.profTextOrder,
                children:<Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(2,0,2,0),
                    child:usFun.buildRoundButton(() => print("Go2Profile"), widget.assetImage, blockSize*8),

                  ),



                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                    child: Container(

                      constraints: BoxConstraints(maxWidth: blockSize*70),

                      decoration: BoxDecoration(
                        color: widget.genColor,
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),





                      child:Padding(
                        padding: EdgeInsets.fromLTRB(8, 5, 8, 0),



                        child: widget.textRows.constructSelectableText(),

                      ),

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,0),
                    child:

                    IconButton(
                      icon:Icon(Icons.fiber_pin),
                      color: Colors.white,
                      onPressed: (){



                        if(widget.pinned == true) {

                          widget.pinned = false;
                        } else{
                          widget.pinned = true;


                        }

                        setState(() {});
                        updatePinned = this.widget;

                      },




                    ),

                  ),

                  Text(widget.currentTime.hour.toString()+":"+widget.currentTime.minute.toString()),




                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 40, 10),
              child: Align(
                alignment: widget.yours ? Alignment.centerRight : Alignment.centerLeft,
                child:

                widget.sentBy.constructText(),
              ),
            ),
          ]
      );

  }



}

