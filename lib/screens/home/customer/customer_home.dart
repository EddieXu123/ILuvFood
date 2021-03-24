import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/screens/home/customer/customer_home_map.dart';
import 'package:iluvfood/screens/home/customer/customer_favorites_list.dart';
import 'package:iluvfood/screens/home/customer/customer_profile.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/business_scroll_view.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  int index;

  CustomerHome(int i) {
    index = i;
  }

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

              // if (index == 0) {
              //   return CustomerHomeMap(
              //     auth: _auth,
              //     customer: customer,
              //   );
              // } else {
              //   return CustomerFavoritesList(
              //     auth: _auth,
              //     customer: customer,
              //   );
              // }
              if (index == 0) {
                print("Home Map");
                return CustomerHomeMap(
                  auth: _auth,
                  customer: customer,
                );
              } else if (index == 1) {
                print("Faves List");
                return CustomerFavoritesList(
                  auth: _auth,
                  customer: customer,
                );
              } else {
                print("Customer Profile");
                return CustomerProfile(
                  auth: _auth,
                  customer: customer,
                );
              }
            } else {
              print("LOADING CUSTOMER HOME");
              return Loading();
            }
          },
        ));
  }
}
