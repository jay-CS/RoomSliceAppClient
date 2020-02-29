import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './main.dart';
//import 'package:flutter_login_ui/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final email_Controller = TextEditingController();
  final pass_Controller = TextEditingController();

  bool _RememberMe = false;
  
  //// EMAIL
  /// Creates the Email Text Field
  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child:TextField(
            keyboardType: TextInputType.emailAddress,
            controller: email_Controller,
            style: TextStyle(
              color: Colors.white
              ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white
              ),
              hintText: 'Enter your email!',
              hintStyle: TextStyle(color: Colors.white)
            ),
          )
          )
      ],
    );
  }

  //// PASSWORD 
  /// Creates the Password Text Field
  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child:TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans'
              ),
            controller: pass_Controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white
              ),
              hintText: 'Enter your password!',
              hintStyle: TextStyle(color: Colors.white)
            ),
          )
          )
      ],
    );
  }

  ////
  ///Creates the Remember Me box
  Widget _buildRememberMeCheckBox() {
    return Container(
            height: 25.0,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Checkbox(
                    value: false,
                    checkColor: Colors.greenAccent,
                    activeColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _RememberMe = value;
                      });
                    }
                  ),
                ),
                Text(
                  "Remember me",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0
                  )
                )
              ],
            )
          );
  }

  ////
  /// Creates the Forgot Password Button 
  Widget _buildForgotPasswordButton() {
    return Container( 
      alignment: Alignment.centerRight,
      child:FlatButton(
        onPressed: () => print("Forgot Password Pressed"),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'OpenSans',
            color: Colors.white
          ),
        ),
      )
    );
  }
   
  ////
  /// Creates the Login Button 
  Widget _buildLoginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if(email_Controller.text == "jay") {
            Navigator.push(
             context,
            MaterialPageRoute(builder: (context) => Roomify()),
            );
            print(email_Controller.text);
          }
        },
        padding:EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
          ),
        color: Colors.white,
        child: Text(
          "Login",
          style:TextStyle(
            color: Colors.purple,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans"
            )
          )
        )
      );
  }

  //Creates Text that say "Sign in with" 
  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '-OR-',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400
          )
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
           style: TextStyle(
           color: Colors.white,
           fontWeight: FontWeight.bold,
           fontSize: 16.0
          ),
        )
      ],
    );
  }

////
/// Creates a logo for each alternative sign in option a person has 
Widget _buildSocialButton(Function onTap, AssetImage logo) {
  return GestureDetector (
    onTap: onTap,
    child: Container(
      height: 60.0,
      width: 60.0,
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

////
///Construcuts a row of the alternative people can use to sign in/ register with
Widget _buildSocialButtonRow() {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: <Widget>[
          _buildSocialButton(() => print("Login with Facebook"), AssetImage("assets/logos/facebook.jpg")),
          _buildSocialButton(() => print("Login with Google"), AssetImage("assets/logos/google.jpg")),
      ]
      ),
  );
}

////
/// Creates the button that allows for people to sign up and register an account 
Widget _buildSignUpButton() {
  return GestureDetector(
    onTap: () => print("Sign up button pressed"),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an Account?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400
            )
          ),
          TextSpan(
            text: ' Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold
            )
          )
        ] 
      ),
    )
  );
}
  //// Constructs the entire login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                      Colors.purple[100],
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'RoomSlice',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmail(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPassword(),
                      _buildForgotPasswordButton(),
                      _buildRememberMeCheckBox(),
                      _buildLoginButton(),
                      _buildSignInWithText(),
                      _buildSocialButtonRow(),
                      _buildSignUpButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}