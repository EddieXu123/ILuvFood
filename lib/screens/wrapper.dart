import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/user.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/authenticate.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/sign_in.dart';
import 'package:iluvfood/screens/authenticate/welcome.dart';
import 'package:iluvfood/screens/home/home.dart';
import 'package:iluvfood/services/account_database.dart';
import 'package:provider/provider.dart';

/*
Use provider to properly display either authentication screens or logged
in screen
*/
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);

    if (user == null) {
      return Welcome();
      // return Authenticate();
    } else {
      return PortalController();
      // print(isCustomer);
      // return Home();
    }
  }
}

class PortalController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('iLuvFood Landing Page'),
        ));
  }
}
