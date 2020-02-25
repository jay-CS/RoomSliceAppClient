
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue
//       ),
//       home: MyHomePage(title: 'Herberts Bitches'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
    
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have added a bitch this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.display1,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.ac_unit),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


// ~~~~~~~~~~~~~~~~~~~~~~~~~~ THE BEGINNING ~~~~~~~~~~~~~~~~~~~~~~~~~~~



import 'package:flutter/material.dart';
import './billsPage.dart';
import './homePage.dart';
import './messagePage.dart';
import './settingsPage.dart';
import './taskPage.dart';
import './loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home:LoginPage()
      );
  }
}
class Roomify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RoomifyState();
  }
}

class RoomifyState extends State<Roomify>{
  int _selectedPage = 0;
  final _pageOptions = [
      MessagePage(),
      TaskPage(),
      HomePage(),
      BillsPage(),
      SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Roomify",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home:Scaffold(
        appBar: AppBar(title: Text("Roooooomie"),),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState((){
              _selectedPage = index;
            });
          },

          items: [
            //Message Board Page
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                color: Colors.purple
                ),
              title: Text("Messages", style: TextStyle(color: Colors.purple)),
            ),
           //Tasks Page
            BottomNavigationBarItem(
              icon: Icon(
                Icons.format_list_bulleted,
                color: Colors.purple
              ),
              title: Text("Tasks", style: TextStyle(color: Colors.purple))
            ),
            
            //Home Page
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.purple,
                ),
              title: Text("Home", style: TextStyle(color: Colors.purple))
            ),
            
            //Bills Page
            BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
                color: Colors.purple
                ),
              title: Text("Bills", style: TextStyle(color: Colors.purple))
            ),

            //Settings Page
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.purple
                ),
              title: Text("Settings", style: TextStyle(color: Colors.purple))

            ),
          ],
        ),

      )
    );
  }
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Login UI',
//       debugShowCheckedModeBanner: false,
//       home:loginPage());
//   }
// }

// class loginPage extends StatefulWidget {
//   @override
//   _loginPageState createState() => _loginPageState();

// }

// class _loginPageState extends State<loginPage> {
  
//   bool _rememberMe = false;
  
//   Widget _buildEmail() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "Email",
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: BoxDecoration(),
//           height: 60.0,
//           child:TextField(
//             keyboardType: TextInputType.emailAddress,
//             style: TextStyle(
//               color: Colors.white
//               ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.white
//               ),
//               hintText: 'Enter your email!',
//             ),
//           )
//           )
//       ],
//     );
//   }

//   Widget _buildPassword() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "Password",
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: BoxDecoration(),
//           height: 60.0,
//           child:TextField(
//             obscureText: true,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans'
//               ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.lock,
//                 color: Colors.white
//               ),
//               hintText: 'Enter your password!',
//             ),
//           )
//           )
//       ],
//     );
//   }

//   Widget _buildRememberMeCheckBox() {
//     return Container(
//             height: 20.0,
//             child:Row(
//               children: <Widget>[
//                 Theme(
//                   data: ThemeData(unselectedWidgetColor: Colors.white),
//                   child: Checkbox(
//                     value: false,
//                     checkColor: Colors.greenAccent,
//                     activeColor: Colors.white,
//                     onChanged: (value) {
//                       setState(() {
//                         _rememberMe = value;
//                       });
//                     }
//                   ),
//                 ),
//                 Text("Remember me")
//               ],
//             )
//           );
//   }

//   /**
//    * Widget _buildPasswordButton(
//    * return 
//    * )
//    */

//   Widget _buildLoginButton() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 25.0),
//       width: double.infinity,
//       child: RaisedButton(
//         elevation: 5.0,
//         onPressed: () => print("Login Button Pressed"),
//         padding:EdgeInsets.all(15.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0)
//           ),
//         color: Colors.white,
//         child: Text(
//           "Login",
//           style:TextStyle(
//             color: Color(0xFF527DAA),
//             letterSpacing: 1.5,
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//             fontFamily: "OpenSans"
//             )
//           )
//         )
//       );
//   }

//   Widget _buildSignInWithText() {
//     return Column(
//       children: <Widget>[
//         Text(
//           '-OR-',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w400
//           )
//         ),
//         SizedBox(height: 20.0),
//         Text(
//           'Sign in with',
//         )
//       ],
//     );
//   }

// Widget _buildSocialButton(Function onTap, AssetImage logo) {
//   return GestureDetector (
//     onTap: onTap,
//     child: Container(
//       height: 60.0,
//       width: 60.0,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0,2),
//             blurRadius: 6.0,
//           )
//         ],
//         image: DecorationImage(
//           image: logo,
//         )
//       ),
//     ),
//   );
// }

// Widget _buildSocialButtonRow() {
//   return Padding(
//       padding: EdgeInsets.symmetric(vertical: 60.0),
//       child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
//       children: <Widget>[
//           _buildSocialButton(() => print("Login with facebook"), AssetImage("assets/logos/facebook.jpg")),
//           _buildSocialButton(() => print("Login with Google"), AssetImage("assets.logos/google.jpg")),
//       ]
//       ),
//   );
// }

// Widget _buildSignUpButton() {
//   return GestureDetector(
//     onTap: () => print("Sign up button pressed"),
//     child: RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: 'Don\'t have an Account?',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//               fontWeight: FontWeight.w400
//             )
//           ),
//           TextSpan(
//             text: 'Sign Up',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold
//             )
//           )
//         ] 
//       ),
//     )
//   );
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFF73AEF5),
//                       Color(0xFF61A4F1),
//                       Color(0xFF478DE0),
//                       Color(0xFF398AE5),
//                     ],
//                     stops: [0.1, 0.4, 0.7, 0.9],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: double.infinity,
//                 child: SingleChildScrollView(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 40.0,
//                     vertical: 120.0,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         'Sign In',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'OpenSans',
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 30.0),
//                       _buildEmail(),
//                       SizedBox(
//                         height: 30.0,
//                       ),
//                       _buildPassword(),
//                       //_buildForgotPassword(),
//                       _buildRememberMeCheckBox(),
//                       _buildLoginButton(),
//                       _buildSignInWithText(),
//                       _buildSocialButtonRow(),
//                       _buildSignUpButton(),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }