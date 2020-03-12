

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'textWrapper.dart';


double scrnWidth = 0;
double scrnHeight = 0;
double blockSize = 0;
double blockSizeVertical = 0;

@override

class HomePage extends StatelessWidget {


  Widget build(BuildContext context) {


    scrnWidth = MediaQuery.of(context).size.width;
    scrnHeight = MediaQuery.of(context).size.height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;

    TextWrapper genText = new TextWrapper(context);
    List <Widget> statusBarText = new List<Widget>();
//------------------------------------STATUS BAR TEXT------------------------------
    double statusBarHeight = blockSizeVertical*3;
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontWeight: FontWeight.bold,
    ));
    genText.setData("Status: ");
    statusBarText.add(genText.constructText());
    statusBarText.add(statusGenerator(1, statusBarHeight));
    genText.setData("Home (Do Not Disturb)");
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontStyle: FontStyle.normal,
    ));


    statusBarText.add(


        genText.constructText());


//------------------------------------STATUS BAR TEXT------------------------------
    int userID; //TEMP, will be taken from DB presumably




    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
              children: <Widget>[

                Container(

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purple[400],
                        Colors.purple[300],
                        Colors.purple[200],
                        Colors.purple[100],
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      //_addText("", blockSizeVertical*9 , TextAlign.left, FontWeight.normal, FontStyle.normal),
                      _addText("Household Info", blockSizeVertical*3 , TextAlign.left, FontWeight.normal, FontStyle.normal),
                      _buildProfilePicRow(blockSizeVertical*20, context),
                      _addText( "Rommate Name",  blockSizeVertical*4.0, TextAlign.center, FontWeight.normal, FontStyle.normal),
                      _addText("", blockSizeVertical*1.0, TextAlign.center, FontWeight.normal, FontStyle.normal),


                      _addColorBarText(statusBarText, statusBarHeight+10),

//-------------------------ROOMMATE STATUS LIST-------------------------
                      Container(

                        height: 42* blockSizeVertical,
                        child:
                        ListView.builder(

                          shrinkWrap: true,
                          padding: const EdgeInsets.all( 2),
                          itemCount:15, //dynamic
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              height: 9*blockSizeVertical,

                              color: Colors.purple[500],
                              child: _addStatusRow(userID, context, 2),
                            );
                          },


                        ),

                      ),

//-------------------------ROOMMATE STATUS LIST-------------------------

                    ],
                  ),





                ),

              ]),



        ),
      ),

    );
  }



  Widget _buildProfilePicRow( double size, BuildContext context ) { //will likely eventually include userID parameter or the like to load current profile pics
    return Padding(
      padding: EdgeInsets.symmetric(vertical: blockSizeVertical*1.5, horizontal: blockSize*2),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildRoundButton(() => print("Change Profile Pic"), AssetImage("assets/logos/profilePic.png"), size),


          ]
      ),
    );
  }

  /// Creates a logo for each alternative sign in option a person has
  Widget _buildRoundButton(Function onTap, AssetImage logo, double diameter) {
    return GestureDetector (
      onTap: onTap,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0,2),
                blurRadius: 6.0,
              )
            ],
            image: DecorationImage(
              image: logo,
            )
        ),
      ),
    );
  }



  Widget _addText(String label, double fontSize, TextAlign alignment, FontWeight fontWeight, FontStyle fontStyle) {
    return Text(
        label,
        textAlign: alignment,
        style: TextStyle(color: Colors.white.withOpacity(1.0),
          fontSize:  fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decorationColor: Colors.blue,


        ));
  }



  Widget _addTextRow(List<Widget> widgList) {


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: widgList,

    );
  }


  Widget _addColorBarText(List<Widget> widgList, double height){

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.white),

          bottom: BorderSide(width: 1.0, color: Colors.white),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
            Colors.blue[100],
          ],),),
      child:


      _addTextRow(widgList),
    );



  }



  Widget  _addStatusRow(int userID, BuildContext context, int status){

    TextWrapper genText = new TextWrapper(context);
    List <Widget> roommateStatusBarText = new List<Widget>();
//------------------------------------STATUS BAR TEXT------------------------------
    double statusBarHeight = blockSizeVertical*2.5;
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ));
    genText.setData("Bob: ");
    roommateStatusBarText.add(genText.constructText());
    genText.setData("At School");
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontStyle: FontStyle.normal,
      color: Colors.white,
    ));
    roommateStatusBarText.add(genText.constructText());
//------------------------------------STATUS BAR TEXT------------------------------

    Icon genStatus = statusGenerator(status, statusBarHeight);


    return


      Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            border:Border.all(color: Colors.black, width: .5),
          ),
          child:
          Row(

              mainAxisAlignment: MainAxisAlignment.start,


              children: <Widget>[



                _buildProfilePicRow( blockSizeVertical*5.5, context ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),

                  child: genStatus,
                ),
                roommateStatusBarText[0],
                roommateStatusBarText[1],

              ]
          ));

  }



  Icon statusGenerator(int status, double height){



    switch (status){

      case 1:

        return Icon(
          Icons.lens,
          color: Colors.green,
          size: height,

        );

        break;

      case 2:

        return Icon(
          Icons.lens,
          color: Colors.yellow,
          size: height,
        );

        break;

      case 3:

        return Icon(
          Icons.lens,
          color: Colors.red,
          size: height,
        );

        break;

      default:

        return Icon(
          Icons.error,
          color: Colors.grey,
          size: height,
        );

    }




  }





}

