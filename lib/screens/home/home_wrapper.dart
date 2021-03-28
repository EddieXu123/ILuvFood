import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/screens/home/customer/customer_home_controller.dart';
import 'package:iluvfood/screens/home/business/business_home.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/enum.dart';
import 'package:iluvfood/shared/errorPage.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

/*
controller for business or customer homes
*/
class HomeWrapper extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Role>(
        stream: DatabaseService(uid: Provider.of<User>(context).uid).userRole,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Role role = snapshot.data;
            switch (role) {
              case (Role.CUSTOMER):
                print("Logging into Customer portal");
                return CustomerHomeController();
              case (Role.BUSINESS):
                print("Logging into Business portal");
                return BusinessHome();
              default:
                print("Bad role, do something, maybe logout?");
                return ErrorPage();
            }
          } else {
            print("LOADING HOME WRAPPER");
            return Loading();
          }
        });
  }
}
