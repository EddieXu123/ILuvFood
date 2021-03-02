import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

/*
Customer landing page after they log in
*/
class BusinessHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Business>(
        stream:
            DatabaseService(uid: Provider.of<User>(context).uid).businessData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Business business = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                  title: Text(
                      '${business.restaurantName ?? "<no name found>"} Menu Portal'),
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
          } else {
            print("WHAT");
            return Loading();
          }
        });
  }
}
