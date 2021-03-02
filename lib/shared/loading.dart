import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*
Spinner class for loading
*/
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        )));
  }
}
