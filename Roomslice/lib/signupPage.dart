import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './loginPage.dart';


class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController fName;
  TextEditingController lName;
  TextEditingController eName;
  TextEditingController tNum;
  TextEditingController pass;
  TextEditingController confPass;

  
  Widget _buildLoginButton() {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()),);
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w600
            )
          ),
          TextSpan(
            text: ' Log in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              fontFamily: "Comic Sans"
            )
          )
        ] 
      ),
    )
  );
}
  
  /// Creates the Register Button 
  Widget _buildRegisterButton() {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 20, left: 22, right: 22),
      width: 300,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          print("REGISTER!");
        },
        padding:EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
          ),
        color: Colors.white,
        child: Text(
          "Register",
          style:TextStyle(
            color: Colors.purple,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Open Sans"
            )
          )
        )
      );
  }

  Widget _buildPasswordField(String textField, String hintText, TextEditingController controller) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          height: 30,
          width: 90,
          child: Text(
            textField,
            style:TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: "Comic Sans"
            )
          ),
        ),
        Container(
          height: 40,
          width: 245,
          padding: EdgeInsets.only(left: 9),
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              )
          ]),
          child: TextField(
            obscureText: true,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.0
              ),
              icon: Icon(
                Icons.person,
                size: 20,
                color: Colors.white
              )
            ),
          ),
        )
      ],
    );
  }
  

  Widget _buildInformationField(String textField, String hintText, TextEditingController controller) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          height: 30,
          width: 90,
          child: Text(
            textField,
            style:TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: "Comic Sans"
            )
          ),
        ),
        Container(
          height: 40,
          width: 245,
          padding: EdgeInsets.only(left: 9),
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              )
          ]),
          child: TextField(
            obscureText: true,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.0
              ),
              icon: Icon(
                Icons.person,
                size: 20,
                color: Colors.white
              )
            ),
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child:GestureDetector(
          child: Stack(
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
                        Colors.purple[200],
                      ],
                      stops: [0.1, 0.3, 0.5, 0.7],
                    ),
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 75.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "INSERT ROOMSLICE LOGO!!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontFamily: "Comic Sans",
                        )
                      ),
                      SizedBox(height: 45.0),
                      _buildInformationField("First Name:", "Enter your first name",fName),
                      SizedBox(height: 35.0),
                      _buildInformationField("Last Name:", "Enter your last name",lName),
                      SizedBox(height: 35.0),
                      _buildInformationField("Email:", "Enter your email",eName),
                      SizedBox(height: 35.0),
                      _buildInformationField("Number:", "Enter your number",tNum),
                      SizedBox(height: 35.0),
                      _buildPasswordField("Password:", "Enter your password",pass),
                      SizedBox(height: 35.0),
                      _buildPasswordField("Password:", "Re-enter your password",confPass),
                      _buildRegisterButton(),
                      _buildLoginButton()
                    ]
                  )
              ),
            ],
          ),
        )
      ),
    );
  }
}