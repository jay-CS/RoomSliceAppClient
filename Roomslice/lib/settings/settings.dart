import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomslice/loginPage.dart';
import 'package:roomslice/main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}


  class _SettingsPageState extends State<SettingsPage> {
    bool notificationisOn = true;
    bool faceIDisOn = true;
    bool twofactorisOn = true;
    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        //Might Not need to use a Stack 
          child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget> [
                  Container(
                    color: Colors.purple[200],
                  ),
                  Column(
                      children: <Widget>[ Container(
                      //alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
                        height: 750,
                        width: 500,
                        padding: EdgeInsets.only(left: 15.00),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.00),
                            child: Text("Account Settings")
                          ),
                          Expanded(
                            child: _buildTile1(context),
                          ),
                         
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.00),
                            child: Text("Security and Notifcations")
                          ),
                           Expanded(
                            child: _buildTile2(context),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.00),
                            child: Text("Languages")
                          ),
                          Expanded(
                            child: _buildTile3(context),
                          ),
                          Container(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service and Conditions',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400
                                    )
                                  ),
                                ] 
                              ),
                            )
                          ),

                          Container(
                            padding: EdgeInsets.only(bottom: 20.0,top:20.0),
                            child: RaisedButton(
                              color: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()),);
                              },
                            ),
                          ),
                        ]
                      )
                    ),
                  ]
                )
              ]
            ),
          );
    }

  //Builds all the necessary items a user can navigate to look/change information 
  Widget _buildTile1(BuildContext con) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(
        context: con,
        tiles: [
        ListTile(
          leading: CircleAvatar(
            //backgroundImage: 
          ),
          title: Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "Update Profile",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            print("Update Profile Pressed");
          }
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/logos/lock.png"),
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "Change Password",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            print("Update Password Pressed");
          }
        ),

        ListTile(
          leading: CircleAvatar(
            //backgroundImage: ,
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "Change Email",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            print("Update Email Pressed");
          }
        ),
    ]).toList()
    );
  }




Widget _buildTile2(BuildContext con) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(
        context: con,
        tiles: [
          ListTile(
          leading: CircleAvatar(
            //backgroundImage: ,
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "Notification",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
          trailing: CupertinoSwitch(
            value: notificationisOn,
            onChanged: (bool value) {
              setState(() {
                print("Notifications Button Pressed");
                notificationisOn = value;
              });
            }),
            onTap: () {
              setState(() {
                notificationisOn = !notificationisOn;
              });
          }
        ),

        ListTile(
          leading: CircleAvatar(
            //backgroundImage: ,
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "Enable FaceID ",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
          trailing: CupertinoSwitch(
            value: faceIDisOn,
            onChanged: (bool value) {
              setState(() {
                print("FACEID Button Pressed");
                faceIDisOn = value;
              });
            }),
            onTap: () {
              setState(() {
                faceIDisOn = !faceIDisOn;
              });
            }
        ),
        ListTile(
          leading: CircleAvatar(
            //backgroundImage: ,
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "Two-Factor Authentication",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
          trailing: CupertinoSwitch(
            value: faceIDisOn,
            onChanged: (bool value) {
              setState(() {
                print("Two Factor Authentication Pressed");
                twofactorisOn = value;
              });
            }),
            onTap: () {
              setState(() {
                twofactorisOn = !faceIDisOn;
              });
            }
        ),
        ]
      ).toList()
    );
  }

  Widget _buildTile3(BuildContext con) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(
        context: con,
        tiles: [
          ListTile(
          leading: CircleAvatar(
            //backgroundImage: ,
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0),
                      child: Text(
              "English",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "OpenSans",
              )
            ),
          ),
            onTap: () {
            print("Update Profile Pressed");
          }
        ),
        ]
      ).toList()
    );
  }

 }