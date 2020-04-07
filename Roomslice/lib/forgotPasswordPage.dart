import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './loginPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

Widget _buildInstructions() {
  return Container(
      child: RichText(
        text: TextSpan(
          children:[ TextSpan(
            text: "Enter your RoomSlice ",
          ),
          TextSpan(
            text: "email address.",
            style: TextStyle(
              color: Colors.white,
              fontWeight:FontWeight.bold
            )
          ),
          TextSpan(
            text: "We'll send you an "
          ),
          TextSpan(
            text: "email ",
            style: TextStyle(
              color: Colors.white,
              fontWeight:FontWeight.bold
            )
          ),
          TextSpan(
            text: "with reset instructions."
          ),
          ]
        )
      )
    );
}

Widget _buildForgotPassword() {
  return GestureDetector(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Open Sans",
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 45.0,
          width: 275,
          padding: EdgeInsets.symmetric(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(14.00),
            boxShadow: [BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 2)
            )]
          ),
          child: TextField(
            //controller: emailController,
            style: TextStyle(
              color: Colors.white
            ),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.email,
                size: 13.0,
                color: Colors.white,
              ),
              hintText: 'Enter your email!',
              hintStyle: TextStyle(color: Colors.white)
            ),
          ),
        ),

      ],
    )
  );
}


Widget _buildResetPasswordButton() {
  return GestureDetector(
    child: Container(
    width: 250,
    padding: EdgeInsets.only(top: 25.0, bottom: 10),
      child: RaisedButton(
        elevation: 5.00,
        onPressed: () {
          print("FUCK IM HIGH");
        },
        padding:EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.deepPurple,
        child: Text(
          "Reset Password",
          style:TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans"
          )
        )
      ),
    ),
  );
}

Widget _buildCancelButton() {
  return Container(
    child: FlatButton(
      onPressed: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()),);
      },
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.blue[700],
          fontSize: 20.0,
          fontFamily: "Open Sans",
          fontWeight: FontWeight.bold
          //decoration: TextDecoration.underline
        ),
      ),
    )
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child:Stack(
          children: <Widget>[
            Container(
                height: double.infinity,
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
              ),
            Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: 60.0,
                  vertical: 60.0,
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Password Reset",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(height: 150.0),
                    _buildInstructions(),
                    SizedBox(height: 35.0),
                    _buildForgotPassword(),
                    _buildResetPasswordButton(),
                    _buildCancelButton()
                  ]
                )
              )
            ),
            
          ],
        )
      ),
    );
  }
}