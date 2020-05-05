import 'package:flutter/material.dart';


class BillsPage extends StatefulWidget {
BillsPage({Key key}) : super(key:key);
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(25.0),
      child: Text("Settings Page", style: TextStyle(fontSize: 36.0),),
    );
  }
}
