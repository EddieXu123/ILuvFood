import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/screens/home/business/business_orders.dart';
import 'package:iluvfood/screens/home/business/business_menu.dart';
import 'package:iluvfood/screens/home/business/business_profile.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class BusinessHome extends StatefulWidget {
  @override
  _BusinessHomeState createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Business>(
        stream: DatabaseService(uid: user.uid).businessData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Business business = snapshot.data;
            return new Scaffold(
              appBar: AppBar(
                  title: Text(
                      '${business.businessName ?? "<no name found>"} Portal'),
                  elevation: 0.0,
                  actions: <Widget>[
                    TextButton.icon(
                      icon: Icon(Icons.person),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      label: Text('logout'),
                    )
                  ]),
              resizeToAvoidBottomInset: false,
              body: ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 48.0,
                    height: 100.0,
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.history),
                        title: Text('Orders'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessOrders(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 48.0,
                    height: 100.0,
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Menu'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessMenu(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 48.0,
                    height: 100.0,
                    child: Card(
                      child: ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text('Profile'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusinessProfile(),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            );
          } else {
            print("LOADING BUSINESS HOME");
            return Loading();
          }
        });
  }
}
