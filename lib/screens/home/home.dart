import 'package:flutter/material.dart';
import 'package:iluvfood/services/auth.dart';

/*
Customer landing page after they log in
*/
class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
          title: Text('iLuvFood Landing Page'),
          backgroundColor: Colors.pink,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text('logout'),
            )
          ]),
    );
  }
}
