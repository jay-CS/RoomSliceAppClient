import 'package:flutter/material.dart';



class UsefulFunctions {

  UsefulFunctions ();

  Widget buildRoundButton(Function onTap, AssetImage logo, double diameter) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
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

}