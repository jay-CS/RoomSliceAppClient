import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    return Scaffold(
      body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: _pageOptions[_selectedPage],
          ),
        ),
      bottomNavigationBar: CurvedNavigationBar(
          key: _navKey,
          index: 2,
          height: 50.0,
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
            ), 
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _selectedPage = index;
            });
          },
        ),
        
      );
  }
}