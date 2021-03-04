import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/single_business_view.dart';
import 'package:provider/provider.dart';

class TestDrawer extends StatefulWidget {
  final AuthService auth;
  TestDrawer({this.auth});
  @override
  _TestDrawerState createState() => _TestDrawerState();
}

class _TestDrawerState extends State<TestDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Hi!'),
            decoration: BoxDecoration(color: MyColors.myPurple),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              await widget.auth.signOut();
            },
          ),
          ListTile(
            title: Text('Coming soon..'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
