import 'package:flutter/material.dart';
import 'package:iluvfood/screens/home/business/business_profile.dart';

import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';

class BusinessDrawer extends StatefulWidget {
  @override
  _BusinessDrawerState createState() => _BusinessDrawerState();
}

class _BusinessDrawerState extends State<BusinessDrawer> {
  final AuthService _auth = AuthService();

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
              Navigator.pop(context);
              await _auth.signOut();
            },
          ),
          ListTile(
            title: Text('Update Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BusinessProfile()));
            },
          ),
        ],
      ),
    );
  }
}
