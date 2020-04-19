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

String dropdownValue = 'One';

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
  List<MessageBox> empty= [];

  int switchVal = 0;



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


          Container(

            color: Colors.white70,
            child:


            ExpansionTile(

              title: Text("Pinned Messages (" + pinned.length.toString()+")"),


              backgroundColor: Colors.grey,
              children: pinned,
              onExpansionChanged:  (bool value) {

                switchVal = 1;

                FocusScope.of(context).requestFocus(FocusNode());


              },

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

              onTap: ()
              {


                switchVal = 0;


              },

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
                  //setState(() {}); Needed?
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

      updatePinned = null;
    }



  }

  List<MessageBox> checkKeyboard(){
    if (switchVal == 0){
      return empty;
    } else{

      return pinned;
    }


  }


}


class MessageBox extends StatefulWidget{


  TextWrapper textRows;
  TextWrapper sentBy;
  Image imageData;
  Alignment textAlign;
  double fontSize =0;
  int lineWidth=0;
  bool isImage = false;
  Image attachment;
  bool pinned = false;
  bool yours = true;
  Color pinnedColor = Colors.red;
  Color genColor = Colors.white;
  Color theirColor = Colors.purple;
  Color yourColor = Colors.green;
  TextDirection profTextOrder = TextDirection.ltr;
  AssetImage profileImage = AssetImage("assets/logos/profilePic.png");
  DateTime currentTime = new DateTime.now();
  Offset position;





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


      widget.textAlign = Alignment.centerRight;
      widget.textRows.setTextAlign(TextAlign.left);
      widget.genColor = widget.yourColor;
      widget.profTextOrder = TextDirection.rtl;

      if(widget.pinned == true){
        widget.genColor = widget.pinnedColor;
      }

    }
    else{
      widget.textAlign = Alignment.centerLeft;
      widget.genColor = widget.theirColor;
      if(widget.pinned == true){
        widget.genColor = widget.pinnedColor;
      }
    }





    return

      new


      Align(
        alignment: Alignment.centerRight,
        child:

        Container(
          width: scrnWidth,

          child:
          ListTile(
            leading: buildLeadingTrailing(widget.yours),
            trailing: buildLeadingTrailing(!widget.yours),
            title:
            Align(
              alignment: Alignment.centerRight,
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: widget.profTextOrder,
                children:<Widget>[


                  Container(

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
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),



                      child:
                      constructContent(),


                    ),

                  ),

                ],
              ),
            ),

            subtitle:       Align(
              alignment: widget.textAlign,
              child:widget.sentBy.constructText(),
            ),


            onLongPress: (){

              final RenderBox position = context.findRenderObject();

              widget.position = position.localToGlobal(Offset.zero);

              final result = showMenu(
                context: context,
                position: RelativeRect.fromLTRB(widget.position.dx,widget.position.dy,0,0),

                items: <PopupMenuItem<String>>[
                  const PopupMenuItem<String>(
                      child: Text('Copy'), value: 'copy'),
                  const PopupMenuItem<String>(
                      child: Text('Pin'), value: 'pin'),

                ],
              );


              if (result == 'pin'){

                print("PIN BOI");

              }


            },


          ),
        ),


      ) ;

  }


  Widget constructContent(){
    if (widget.isImage){
      return widget.attachment;
    } else {
      return widget.textRows.constructText();
    }
  }


  Widget buildLeadingTrailing( bool isYours){

    if(isYours) {
      return Text(
        widget.currentTime.hour.toString() + ":" +
            widget.currentTime.minute.toString().padLeft(2, '0'),
        textAlign: TextAlign.end,
      );
    } else{

      return CircleAvatar(
        backgroundImage: widget.profileImage,

      );
    }

  }


  void togglePinned(){

    if (widget.pinned == false){

      widget.pinned = true;
    }
    else{
      widget.pinned = false;
    }
    setState(() {});

    updatePinned = widget;

  }



}

