import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import './billsPage.dart';
import './homePage.dart';
import './messagePage.dart';
import './settingsPage.dart';
import './taskPage.dart';
import './loginPage.dart';


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
  int _selectedPage = 2;
  GlobalKey _navKey = new GlobalKey();

  final _pageOptions = [
    MessagePage(),
    TaskPage(),
    HomePage(),
    BillsPage(),
    SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {


    scrnWidth = MediaQuery.of(context).size.width;
    scrnHeight = MediaQuery.of(context).size.height;
    blockSize = scrnWidth / 100;
    blockSizeVertical = scrnHeight / 100;

    return MaterialApp(
        title: "Roomify",
        theme: ThemeData(
        primarySwatch: Colors.deepPurple
    ),
    home:Scaffold(
      primary: false,
      appBar: new AppBar(),
      body: Container(
        color: Colors.purple[100],
        child: Center(
          child: _pageOptions[_selectedPage],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navKey,
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
        backgroundColor: Colors.purple[100],
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