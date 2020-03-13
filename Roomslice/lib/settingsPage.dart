import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textWrapper.dart';
import 'usefulFunctions.dart';

double scrnWidth = 0;
double scrnHeight = 0;
double blockSize = 0;
double blockSizeVertical = 0;

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListDisplay();
  }




}


class ListDisplay extends StatefulWidget {
  @override
  State createState() => new DynamicList();



}

class DynamicList extends State<ListDisplay> {
  List<Widget> messages = [];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build (BuildContext context) {

    scrnWidth = MediaQuery.of(context).size.width;
    scrnHeight = MediaQuery.of(context).size.height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;

    return  Column(

        crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[


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
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: new BorderSide(
                  ),

                ),
                  focusColor: Colors.white,

    ),

                onSubmitted: (text) {


                  TextWrapper genText =new TextWrapper(context);

                  genText.data = text;
                  genText.textWidthBasis = TextWidthBasis.longestLine;
                  genText.setStyle(TextStyle(
                    fontSize: blockSizeVertical*3,
                    color: Colors.black,

                  ));

                  MessageBox msgBox = new MessageBox();
                  msgBox.textRows = genText;
                  messages.insert(0,msgBox);

                  eCtrl.clear();
                  setState(() {});
                },

            ),

),
          ],

    );
  }
}


class MessageBox extends StatefulWidget{

  TextWrapper textRows;
  double fontSize =0;
  int lineWidth=0;
  bool pinned = false;
  bool yours = false;
  Color theirColor = Colors.purple;
  Color yourColor = Colors.green;
  TextDirection profTextOrder = TextDirection.ltr;




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


    if(widget.yours){

      widget.textRows.setTextAlign(TextAlign.left);
      widget.theirColor = widget.yourColor;
      widget.profTextOrder = TextDirection.rtl;

    }


    UsefulFunctions usFun = new UsefulFunctions();


    return

      new




      Align(
        alignment: widget.yours ? Alignment.centerRight : Alignment.centerLeft,
        child:

        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: widget.profTextOrder,
            children:<Widget>[
        Padding(
        padding: EdgeInsets.fromLTRB(2,0,2,8),
              child:usFun.buildRoundButton(() => print("Go2Profile"), AssetImage("assets/logos/profilePic.png"), blockSize*8),

        ),


              Padding(
        padding: EdgeInsets.fromLTRB(0,0,0,8),
child: Container(

            constraints: BoxConstraints(maxWidth: blockSize*70),

          decoration: BoxDecoration(
          color: widget.theirColor,
          border: Border.all(
          color: Colors.black,
          width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
          ),





    child:Padding(
    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),



    child: widget.textRows.constructSelectableText(),

    ),

    ),
              ),




            ],
        ),
    );

  }



}

