import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/business_scroll_view.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

// /*
// Customer landing page after they log in
// */
// class CustomerHome extends StatelessWidget {
//   final AuthService _auth = AuthService();
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Customer>(
//         stream:
//             DatabaseService(uid: Provider.of<User>(context).uid).customerData,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             Customer customer = snapshot.data;
//             return Scaffold(
//               backgroundColor: Colors.brown[50],
//               appBar: ,
//             );
//           } else {
//             print("LOADING CUSTOMER HOME");
//             return Loading();
//           }
//         });
//   }
// }

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
              return BusinessScrollView(
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
