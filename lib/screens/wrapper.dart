import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:iluvfood/screens/authenticate/customer_authenticate/authenticate.dart';
import 'package:iluvfood/screens/authenticate/welcome.dart';

import 'package:iluvfood/screens/home/home_wrapper.dart';

import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either home or Authenticate widget

    final user = Provider.of<User>(context);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          if (user == null) {
            return Welcome();
            // return Authenticate();
          } else {
            // return different home depending on customer or business
            return HomeWrapper();
          }
        }
      },
    );
  }
}
