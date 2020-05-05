import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:roomslice/loginPage.dart';
import 'package:roomslice/main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key:key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}


  class _SettingsPageState extends State<SettingsPage> {
    
    ////
    /// These boolean values are hard coded, however, these need to be data
    /// taken from the server and displayed on the mobile app.
    bool notificationisOn = true;
    bool faceIDisOn = true;
    bool twofactorisOn = true;

    //Builds all the necessary items a user can navigate to look/change information 
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                      children: <Widget>[ Container(
                      //alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 60.0,left: 10.0,right: 10.0),
                        height: 750,
                        width: 500,
                        padding: EdgeInsets.only(left: 15.00),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 10.0, top: 20.0),
                            child: Text("Account Settings")
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            height: 175,
                              child: _buildTile1(context),
                            
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.00),
                            child: Text("Security and Notifcations")
                          ),
                           Container(
                            alignment: Alignment.bottomRight,
                            height: 175,
                            
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
                          GestureDetector(
                            onTap: () {
                              print("Terms of Service and Conditions pressed");
                            },
                            child: Container(
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

    Widget _buildTile1(BuildContext con) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, int index) {
      if( index == 0) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/logos/profile.png"),
          ),
          title: Padding(
                      padding: EdgeInsets.only(left:15.0,top:5.0),
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
        );
      }
      if( index == 1) {
        return ListTile(
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
        );
      }
      else {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/logos/envelope.png"),
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
        );
      }
      }
    );
  }

    Widget _buildTile2(BuildContext con) {

    return ListView(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(
        
        context: con,
        tiles: [
          ListTile(
          
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/logos/notifications.png"),
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0,top:0.0),
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
            backgroundImage: AssetImage("assets/logos/faceid.png"),
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
            backgroundImage: AssetImage("assets/logos/twofactor.jpeg"),
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
            value: twofactorisOn,
            onChanged: (bool value) {
              setState(() {
                print("Two Factor Authentication Pressed");
                twofactorisOn = value;
              });
            }),
            onTap: () {
              setState(() {
                twofactorisOn = !twofactorisOn;
              });
            }
        ),
        ]
      ).toList()
    );
  }

    Widget _buildTile3(BuildContext con) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(
        context: con,
        tiles: [
          ListTile(
          leading: CircleAvatar(
            //backgroundImage: ,
          ),
          title: Padding(
            padding: EdgeInsets.only(left:15.0,),
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