import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/screens/home/customer/customer_home_map.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Business>>.value(
        value: DatabaseService().businesses,
        child: StreamBuilder<Customer>(
          stream:
              DatabaseService(uid: Provider.of<User>(context).uid).customerData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Customer customer = snapshot.data;
/*
              return BusinessScrollView(
                auth: _auth,
                customer: customer,
              );
*/
              return CustomerHomeMap(
                auth: _auth,
                customer: customer,
              );
            } else {
              print("LOADING CUSTOMER HOME");
              return Loading();
            }
          },
        ));
  }
}
