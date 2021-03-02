import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Oops!"),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Something went wrong'),
      ),
    );
  }
}
