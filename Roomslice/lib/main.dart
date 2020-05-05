import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:roomslice/forgotPasswordPage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:roomslice/signupPage.dart';
import './billsPage.dart';
import './homePage.dart';
import './messagePage.dart';
import './tasks/taskPage.dart';
import './loginPage.dart';
import './FileWriter.dart';
import './settings/settings.dart';

double scrnWidth = 0;
double scrnHeight = 0;
double blockSize = 0;
double blockSizeVertical = 0;


void main() => runApp(MyApp());



class MyApp extends StatelessWidget{
  
  
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        title: 'Flutter Login UI',
        debugShowCheckedModeBanner: false,
        initialRoute: "Login Page",
        home:Roomify(),
        routes: <String, WidgetBuilder>{
        'Login Page' : (context) => LoginPage(),
        'Roomify': (context) => Roomify(),
        'ForgotPasswordPage': (context) => ForgotPasswordPage(),
        'SignpPage ' : (context) => SignupPage(),
    },
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


  
  FileWriter fw = new FileWriter();
  int _selectedPage = 2;
  
  final PageStorageBucket bucket = PageStorageBucket();
  final Key pageOne = PageStorageKey("1");
  final Key pagetwo = PageStorageKey("2");
  final Key pagethree = PageStorageKey("3");
  final Key pagefour = PageStorageKey("4");
  final Key pagefive = PageStorageKey("5");

    List<Widget> _pageOptions;
    Widget currentPage;
    MessagePage m;
    HomePage h;
    SettingsPage s;
    BillsPage b;
    TaskPage t;
    
    @override 
    void initState() {
      h = HomePage();
      m = MessagePage();
      b = BillsPage();
      t = TaskPage();
      s = SettingsPage();
      _pageOptions = [m,t,h,b,s];
      super.initState();
    }

 

  @override
  Widget build(BuildContext context) {


    scrnWidth = MediaQuery.of(context).size.width;
    scrnHeight = MediaQuery.of(context).size.height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;

    return WillPopScope(
      onWillPop: () async => false,
          child: Scaffold(
        primary: false,
        //appBar: new AppBar(),
        body: Container(
            color: Colors.purple[100],
            child: Center(
              child: _pageOptions[_selectedPage],
            ),
          ),
        bottomNavigationBar: CurvedNavigationBar(
          index: 2,
          height: blockSizeVertical*7,
          items: <Widget>[

            Icon(
              Icons.message,
              color: Colors.purple,
              size: 25,
            ),

            Icon(
              Icons.format_list_bulleted,
              color: Colors.purple,
              size: 25,
            ),

            Icon(
              Icons.home,
              color: Colors.purple,
              size: 25,
            ),

            Icon(
              Icons.monetization_on,
              color: Colors.purple,
              size: 25,
            ),
            Icon(
              Icons.settings,
              color: Colors.purple,
              size: 25,
            )
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.purple[400],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _selectedPage = index;
            });
          },
        ),
      ),
    );
  }
}


// scrnWidth = MediaQuery.of(context).size.width;
//     scrnHeight = MediaQuery.of(context).size.height;
//     blockSize = scrnWidth / 100;
//     blockSizeVertical = scrnHeight / 100;

//     return MaterialApp(
//         title: "Roomify",
//         theme: ThemeData(
//         primarySwatch: Colors.deepPurple
//     ),
//     home:Scaffold(
//       primary: false,
//       appBar: new AppBar(),
//       body: Container(
//         color: Colors.purple[100],
//         child: Center(
//           child: _pageOptions[_selectedPage],
//         ),
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _navKey,
//         index: 2,
//         height: blockSizeVertical*7,
//         items: <Widget>[

//           Icon(
//             Icons.message,
//             color: Colors.purple,
//             size: 25,
//           ),

//           Icon(
//             Icons.format_list_bulleted,
//             color: Colors.purple,
//             size: 25,
//           ),

//           Icon(
//             Icons.home,
//             color: Colors.purple,
//             size: 25,
//           ),

//           Icon(
//             Icons.monetization_on,
//             color: Colors.purple,
//             size: 25,
//           ),
//           Icon(
//             Icons.settings,
//             color: Colors.purple,
//             size: 25,
//           )
//         ],
//         color: Colors.white,
//         buttonBackgroundColor: Colors.white,
//         backgroundColor: Colors.purple[100],
//         animationCurve: Curves.easeInOut,
//         animationDuration: Duration(milliseconds: 600),
//         onTap: (index) {
//           setState(() {
//             _selectedPage = index;
//           });
//         },
//       ),
//     ),
//     );