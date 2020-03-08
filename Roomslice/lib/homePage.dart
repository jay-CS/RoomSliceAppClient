import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'textWrapper.dart';


class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    TextWrapper genText = new TextWrapper(context);
    List <Widget> statusBarText = new List<Widget>();
//------------------------------------STATUS BAR TEXT------------------------------
    double statusBarHeight = 22;
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontWeight: FontWeight.bold,
    ));
    genText.setData("Status: ");
    statusBarText.add(genText.constructText());
    genText.setData("Home (Do Not Disturb)");
    genText.setStyle(TextStyle(
      fontSize: statusBarHeight,
      fontStyle: FontStyle.normal,
    ));
    statusBarText.add(genText.constructText());
//------------------------------------STATUS BAR TEXT------------------------------
    int userID; //TEMP, will be taken from DB presumably
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[

              Column(

              children:[
              Container(
                height: MediaQuery.of(context).size.height-162,
                width: double.infinity,
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
                    _addText("Household Info", 20, TextAlign.left, FontWeight.normal, FontStyle.normal),
                    _buildProfilePicRow((MediaQuery.of(context).size.width)/2.2),
                    _addText("Rommate Name", 30, TextAlign.center, FontWeight.normal, FontStyle.normal),



                    _addColorBarText(statusBarText, statusBarHeight+10),

//-------------------------ROOMMATE STATUS LIST-------------------------
                    Container(

                      height: MediaQuery.of(context).size.height/2.6,
                      child:
                    ListView.builder(

                      shrinkWrap: true,
                      padding: const EdgeInsets.all(2),
                      itemCount:15, //dynamic
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          height:80,

                          color: Colors.purple[500],
                          child: _addStatusRow(userID, context),
                        );
                      },


                    ),

                    ),

//-------------------------ROOMMATE STATUS LIST-------------------------

                  ],
                ),


              ),




          ]),

            ],
          ),
        ),
      ),
    );
  }



  Widget _buildProfilePicRow( double size ) { //will likely eventually include userID parameter or the like to load current profile pics
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
        mainAxisAlignment: MainAxisAlignment.center,

        children: widgList,

    );
  }


  Widget _addColorBarText(List<Widget> widgList, double height){

    return Container(
      height: height,
      child:

    Scaffold(
      appBar: AppBar(
        title: _addTextRow(widgList),
      ),

    ));



  }



Widget  _addStatusRow(int userID, BuildContext context){

    TextWrapper genText = new TextWrapper(context);
    List <Widget> roommateStatusBarText = new List<Widget>();
//------------------------------------STATUS BAR TEXT------------------------------
    double statusBarHeight = 18;
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
      _buildProfilePicRow((MediaQuery.of(context).size.width)/11 ),

        roommateStatusBarText[0],
        roommateStatusBarText[1],

      ]
    ));

  }






  }

