
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