import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iluvfood/shared/constants.dart';

/*
Spinner class for loading
*/
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Container(
        color: MyColors.myPurple,
        child: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        )));
  }
}
