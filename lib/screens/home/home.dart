// import 'package:flutter/material.dart';
// import 'package:iluvfood/services/auth.dart';

// /*
// Customer landing page after they log in
// */
// class Home extends StatelessWidget {
//   final AuthService _auth = AuthService();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.brown[50],
//       appBar: AppBar(
//           title: Text('iLuvFood Landing Page'),
//           backgroundColor: Colors.pink,
//           elevation: 0.0,
//           actions: <Widget>[
//             FlatButton.icon(
//               icon: Icon(Icons.person),
//               onPressed: () async {
//                 await _auth.customerSignOut();
//               },
//               label: Text('logout'),
//             )
//           ]),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/models/user.dart';
import 'package:iluvfood/services/account_database.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

/*
Customer landing page after they log in
*/
class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Customer>(
        stream: AccountDatabaseService(uid: Provider.of<AuthUser>(context).uid)
            .customerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Customer customer = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                  title: Text(
                      'Let\'s eat ${customer.firstName} ${customer.lastName}!'),
                  backgroundColor: Colors.pink,
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      onPressed: () async {
                        await _auth.customerSignOut();
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
